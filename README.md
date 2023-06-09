# ESX-PaletoWorks
Basic local paletp jobs and a paleto used car lot for ESX.
Just trying to give the top of the map some love.

Requires esx_skin, skinchanger, esx_jobs, esx_status and my own esx_needtosleep

Thanks to ESX-CityWorks and RC-Mining Job, which were the scripts I looked into to learn the ropes.

Run in SQL:
```
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('electrician', 'Electrician', '0')
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('factory_helper', 'Factory Helper', '0')
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('cleaner', 'Cleaner', '0')
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('police_intern', 'Police Intern', '0')

INSERT INTO `job_grades` (`job_name`, `name`, `label`, `grade`) VALUES ('electrician', 'junior', 'Junior', '0')
INSERT INTO `job_grades` (`job_name`, `name`, `label`, `grade`) VALUES ('factory_helper', 'employee', 'Employee', '0')
INSERT INTO `job_grades` (`job_name`, `name`, `label`, `grade`) VALUES ('cleaner', 'employee', 'Employee', '0')
INSERT INTO `job_grades` (`job_name`, `name`, `label`, `grade`) VALUES ('police_intern', 'intern', 'Intern', '0')

ALTER TABLE `users` ADD `work_experience` JSON NOT NULL DEFAULT '[]' AFTER `pincode`;
```

Add this project to the resources folder and server.cfg and you're done.

This should be a good boilerplate for similar jobs you may want to create with little to no vehicular moving around.
