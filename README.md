# ESX-PaletoWorks
Basic local jobs for ESX.

Requires esx_skin (and possibly the skinchanger) esx_jobs and rc_notify, which I'll replace for a normal notification soon enough.

Thanks to ESX-CityWorks and RC-Mining Job, which were the scripts I looked into to learn the ropes.

Run in SQL:
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('electrician', 'Electrician', '0')
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('factory_helper', 'Factory Helper', '0')
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('cleaner', 'Cleaner', '0')

INSERT INTO `job_grades` (`job_name`, `name`, `label`, `grade`) VALUES ('electrician', 'junior', 'Junior', '0')
INSERT INTO `job_grades` (`job_name`, `name`, `label`, `grade`) VALUES ('factory_helper', 'employee', 'Employee', '0')
INSERT INTO `job_grades` (`job_name`, `name`, `label`, `grade`) VALUES ('cleaner', 'employee', 'Employee', '0')

Add this project to the resources folder and server.cfg and you're done.

This should be a good boilerplate for similar jobs you may want to create with no vehicular moving around.
