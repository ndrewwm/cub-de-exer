select distinct
       dp.dir_uid as username,
       de.mail as email,
       case
          when dp.primaryaffiliation = 'Student'
            or (daf.description like 'Student%' or daf.description = 'Continuing Ed Non-Credit Student')
               then 'Student'
          
          when dp.primaryaffiliation in ('Staff', 'Officer/Professional', 'Employee', 'Faculty')
            or (dp.primaryaffiliation = 'Member' and daf.description = 'Faculty')
               then 'Faculty/Staff'

          else 'Student'
        end as person_type
   from dirsvcs.dir_person dp 
        inner join dirsvcs.dir_affiliation daf
        on daf.uuid = dp.uuid
           and daf.campus = 'Boulder Campus' 
           and daf.description not like 'POI_%'
           and daf.description not in ('Admitted Student', 'Alum', 'Confirmed Student', 'Former Student', 
                                       'Member Spouse', 'Sponsored', 'Sponsored EFL', 'Retiree', 'Boulder3')

        left join dirsvcs.dir_email de
        on de.uuid = dp.uuid
           and de.mail_flag = 'M'
           and de.mail is not null
  where dp.primaryaffiliation not in ('Not currently affiliated', 'Retiree', 'Affiliate', 'Member') -- likely that 'Affiliate' and 'Member' should be removed
    and lower(de.mail) not like '%cu.edu' -- should this be in join clause?
    and de.mail is not null               -- should this be in join clause? is it attempting to filter out rows that *have* a null mail, *after* the join?
    and (
      (dp.primaryaffiliation != 'Student' and lower(de.mail) not like '%cu.edu') or 
      (dp.primaryaffiliation = 'Student' and exists (select 'x' from dirsvcs.dir_acad_career where uuid = dp.uuid))
    )
