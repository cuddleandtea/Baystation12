/obj/item/projectile/animate
	name = "bolt of animation"
	icon_state = "ice_1"
	damage = 0
	damage_type = DAMAGE_BURN
	nodamage = TRUE
	damage_flags = 0

/obj/item/projectile/animate/Bump(atom/change, called)
	if((istype(change, /obj/item) || istype(change, /obj/structure)) && !is_type_in_list(change, GLOB.mimic_protected))
		var/obj/O = change
		new /mob/living/simple_animal/hostile/mimic/(O.loc, O, firer)
	..()
