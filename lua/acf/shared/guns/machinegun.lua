--define the class
ACF_defineGunClass("MG", {
	spread = 0.24,
	name = "Machinegun",
	desc = "Machineguns are light guns that fire equally light bullets at a fast rate.",
	muzzleflash = "mg_muzzleflash_noscale",
	rofmod = 0.9,
	sound = "acf_base/weapons/mg_fire4.mp3",
	soundNormal = "acf_base/weapons/mg_fire4.mp3",
	soundDistance = ""
})

--add a gun to the class
--id
ACF_defineGun("7.62mmMG", {
	name = "7.62mm Machinegun",
	desc = "The 7.62mm is effective against infantry, but its usefulness against armor is laughable at best.",
	model = "models/machinegun/machinegun_762mm.mdl",
	gunclass = "MG",
	caliber = 0.762,
	weight = 15,
	year = 1930,
	rofmod = 1.59,
	magsize = 250,
	magreload = 6, -- Time to reload in seconds
	Cyclic = 700, -- Rounds per minute
	round = {
		maxlength = 13,
		propweight = 0.04
	}
})

ACF_defineGun("12.7mmMG", {
	name = "12.7mm Machinegun",
	desc = "The 12.7mm MG is still light, finding its way into a lot of mountings, including on top of tanks.",
	model = "models/machinegun/machinegun_127mm.mdl",
	gunclass = "MG",
	caliber = 1.27,
	weight = 30,
	year = 1910,
	rofmod = 1, --0.766
	magsize = 150,
	magreload = 6,
	Cyclic = 600,
	round = {
		maxlength = 15.8,
		propweight = 0.03
	}
})

ACF_defineGun("14.5mmMG", {
	name = "14.5mm Machinegun",
	desc = "The 14.5mm MG trades its smaller stablemates' rate of fire for more armor penetration and damage.",
	model = "models/machinegun/machinegun_145mm.mdl",
	gunclass = "MG",
	caliber = 1.45,
	weight = 45,
	year = 1932,
	rofmod = 1, --0.722
	magsize = 90,
	magreload = 5,
	Cyclic = 500,
	round = {
		maxlength = 19.5,
		propweight = 0.04
	}
})