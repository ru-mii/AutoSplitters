state("Capybro") {}

startup
{
     Assembly.Load(File.ReadAllBytes(@"Components/asl-help")).CreateInstance("Unity");
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		vars.Helper["inSpa"] = mono.Make<bool>("ThePlayerControl", "script", "inSpa");
		vars.Helper["cantInteractWithNPC"] = mono.Make<int>("ThePlayerControl", "script", "cantInteractWithNPC");
		
		vars.Helper["quest1"] = mono.Make<bool>("GammyController", "script", "finish1");
		vars.Helper["quest2"] = mono.Make<bool>("GammyController", "script", "finish2");
		vars.Helper["quest3"] = mono.Make<bool>("GammyController", "script", "finish3");
		vars.Helper["quest4"] = mono.Make<bool>("GammyController", "script", "finish4");
		vars.Helper["quest5"] = mono.Make<bool>("GammyController", "script", "finish5");
		vars.Helper["quest6"] = mono.Make<bool>("GammyController", "script", "finish6");
		vars.Helper["quest7"] = mono.Make<bool>("GammyController", "script", "finish7");
		vars.Helper["quest8"] = mono.Make<bool>("GammyController", "script", "finish8");
		vars.Helper["quest9"] = mono.Make<bool>("GammyController", "script", "finish9");
		vars.Helper["quest10"] = mono.Make<bool>("GammyController", "script", "finish10");
				
		return true;
	});
}


start
{
	return current.cantInteractWithNPC != 0 && !current.inSpa;
}

split
{
	if (current.quest1 == true && old.quest1 == false) return true;
	if (current.quest2 == true && old.quest2 == false) return true;
	if (current.quest3 == true && old.quest3 == false) return true;
	if (current.quest4 == true && old.quest4 == false) return true;
	if (current.quest5 == true && old.quest5 == false) return true;
	if (current.quest6 == true && old.quest6 == false) return true;
	if (current.quest7 == true && old.quest7 == false) return true;
	if (current.quest8 == true && old.quest8 == false) return true;
	if (current.quest9 == true && old.quest9 == false) return true;
	if (current.quest10 == true && old.quest10 == false) return true;

	return current.inSpa;
}

reset
{
	return current.cantInteractWithNPC == 0;
}
