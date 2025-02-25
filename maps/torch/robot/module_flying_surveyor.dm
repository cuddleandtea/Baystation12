/obj/item/robot_module/flying/surveyor
	name = "survey drone module"
	display_name = "Surveyor"
	channels = list(
		"Exploration" = TRUE,
		"Science" = TRUE
	)
	networks = list(NETWORK_RESEARCH)
	sprites = list(
		"Drone"  = "drone-science",
		"Eyebot" = "eyebot-science"
	)
	var/list/flag_types = list(
		/obj/item/stack/flag/yellow,
		/obj/item/stack/flag/green,
		/obj/item/stack/flag/red
	)
	skills = list(
		SKILL_ELECTRICAL          = SKILL_MASTER,
		SKILL_ATMOS               = SKILL_MASTER,
		SKILL_PILOT               = SKILL_EXPERIENCED,
		SKILL_BOTANY              = SKILL_MASTER,
		SKILL_EVA                 = SKILL_MASTER,
		SKILL_MECH                = HAS_PERK,
	)

	equipment = list(
		/obj/item/device/flash,
		/obj/item/material/hatchet/machete/unbreakable,
		/obj/item/inducer/borg,
		/obj/item/device/scanner/gas,
		/obj/item/storage/plants,
		/obj/item/wirecutters/clippers,
		/obj/item/device/scanner/mining,
		/obj/item/extinguisher,
		/obj/item/gun/launcher/net/borg,
		/obj/item/device/gps,
		/obj/item/weldingtool/largetank,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/device/multitool,
		/obj/item/bioreactor,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/robot_harvester
	)

	emag_gear = list(
		/obj/item/melee/baton/robot/electrified_arm,
		/obj/item/gun/energy/gun
	)
	access = list(
		access_emergency_storage,
		access_eva,
		access_expedition_shuttle,
		access_explorer,
		access_guppy,
		access_hangar,
		access_petrov,
		access_research,
		access_radio_exp,
		access_radio_sci
	)

/obj/item/robot_module/flying/surveyor/finalize_synths()
	. = ..()
	for(var/flag_type in flag_types)
		equipment += new flag_type(src)

/obj/item/robot_module/flying/surveyor/respawn_consumable(mob/living/silicon/robot/R, amount)
	var/obj/item/gun/launcher/net/borg/gun = locate() in equipment
	if(!gun)
		gun = new(src)
		equipment += gun
	if(LAZYLEN(gun.shells) < gun.max_shells)
		gun.load(new /obj/item/net_shell)

	for(var/flagtype in flag_types)
		var/obj/item/stack/flag/flag = locate(flagtype) in equipment
		if(!flag)
			flag = new flagtype
			equipment += flag
		if(flag.amount < flag.max_amount)
			flag.add(1)
	..()
