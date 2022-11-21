select distinct
       dp.dir_uid as username,
       de.mail as email,

       -- rows w/ primary affiliations of 'Affiliate' and 'Member' are not retained 
       -- in the set of results, so cases dedicated to these values are omitted;
       case
         when dp.primaryaffiliation = 'Student'
           or (dp.primaryaffiliation != 'Student' and 
               daf.edupersonaffiliation in ('Employee', 'Faculty', 'Affiliate') and
               daf.description like '%Student%')
              then 'Student'

         when dp.primaryaffiliation in ('Staff', 'Faculty', 'Officer/Professional')
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

       -- do not keep records with a null address, left --> inner join to simplify
       inner join dirsvcs.dir_email de
       on de.uuid = dp.uuid
          and de.mail_flag = 'M'
          and de.mail is not null
          and lower(de.mail) not like '%cu.edu'
 where dp.primaryaffiliation not in ('Not currently affiliated', 'Retiree', 'Affiliate', 'Member')
   and (dp.primaryaffiliation != 'Student' or
        (dp.primaryaffiliation = 'Student' and exists (select 'x'
                                                         from dirsvcs.dir_acad_career dac
                                                        where dac.uuid = dp.uuid)));
