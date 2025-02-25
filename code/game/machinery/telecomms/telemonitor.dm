//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32


/*
	Telecomms monitor tracks the overall trafficing of a telecommunications network
	and displays a heirarchy of linked machines.
*/


/obj/machinery/computer/telecomms/monitor
	name = "telecommunications monitor"
	icon_screen = "comm_monitor"
	machine_name = "telecomms monitor console"
	machine_desc = "Tracks the traffic of a telecommunications network, and maintains information about connected machines."

	var/screen = 0				// the screen number:
	var/list/machinelist = list()	// the machines located by the computer
	var/obj/machinery/telecomms/SelectedMachine

	var/network = "NULL"		// the network to probe

	var/temp = ""				// temporary feedback messages

/obj/machinery/computer/telecomms/monitor/attack_hand(mob/user as mob)
	if(inoperable())
		return
	user.set_machine(src)
	var/list/dat = list()
	dat += "<TITLE>Telecommunications Monitor</TITLE><center><b>Telecommunications Monitor</b></center>"

	switch(screen)


		// --- Main Menu ---

		if(0)
			dat += "<br>[temp]<br><br>"
			dat += "<br>Current Network: <a href='?src=\ref[src];network=1'>[network]</a><br>"
			if(length(machinelist))
				dat += "<br>Detected Network Entities:<ul>"
				for(var/obj/machinery/telecomms/T in machinelist)
					dat += "<li><a href='?src=\ref[src];viewmachine=[T.id]'>\ref[T] [T.name]</a> ([T.id])</li>"
				dat += "</ul>"
				dat += "<br><a href='?src=\ref[src];operation=release'>\[Flush Buffer\]</a>"
			else
				dat += "<a href='?src=\ref[src];operation=probe'>\[Probe Network\]</a>"


		// --- Viewing Machine ---

		if(1)
			dat += "<br>[temp]<br>"
			dat += "<center><a href='?src=\ref[src];operation=mainmenu'>\[Main Menu\]</a></center>"
			dat += "<br>Current Network: [network]<br>"
			dat += "Selected Network Entity: [SelectedMachine.name] ([SelectedMachine.id])<br>"
			dat += "Linked Entities: <ol>"
			for(var/obj/machinery/telecomms/T in SelectedMachine.links)
				if(!T.hide)
					dat += "<li><a href='?src=\ref[src];viewmachine=[T.id]'>\ref[T.id] [T.name]</a> ([T.id])</li>"
			dat += "</ol>"


	var/datum/browser/popup = new(user, "comm_monitor", "Telecommunications Monitor", 575, 400)
	popup.set_content(jointext(dat, null))
	popup.open()

	temp = ""
	return


/obj/machinery/computer/telecomms/monitor/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)

	if(href_list["viewmachine"])
		screen = 1
		for(var/obj/machinery/telecomms/T in machinelist)
			if(T.id == href_list["viewmachine"])
				SelectedMachine = T
				break

	if(href_list["operation"])
		switch(href_list["operation"])

			if("release")
				machinelist = list()
				screen = 0

			if("mainmenu")
				screen = 0

			if("probe")
				if(length(machinelist) > 0)
					temp = SPAN_COLOR("#d70b00", "- FAILED: CANNOT PROBE WHEN BUFFER FULL -")

				else
					for(var/obj/machinery/telecomms/T in range(25, src))
						if(T.network == network)
							machinelist.Add(T)

					if(!length(machinelist))
						temp = SPAN_COLOR("#d70b00", "- FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN \[[network]\] -")
					else
						temp = SPAN_COLOR("#336699", "- [length(machinelist)] ENTITIES LOCATED & BUFFERED -")

					screen = 0


	if(href_list["network"])

		var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null|text
		if(newnet && ((usr in range(1, src) || issilicon(usr))))
			if(length(newnet) > 15)
				temp = SPAN_COLOR("#d70b00", "- FAILED: NETWORK TAG STRING TOO LENGHTLY -")

			else
				network = newnet
				screen = 0
				machinelist = list()
				temp = SPAN_COLOR("#336699", "- NEW NETWORK TAG SET IN ADDRESS \[[network]\] -")

	updateUsrDialog()
	return

/obj/machinery/computer/telecomms/monitor/emag_act(remaining_charges, mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = TRUE
		req_access.Cut()
		to_chat(user, SPAN_NOTICE("You disable the security protocols"))
		src.updateUsrDialog()
		return 1
