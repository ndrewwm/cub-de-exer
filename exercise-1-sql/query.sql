select distinct dp.dir_uid as username
  ,de.mail as email
  ,case  
    when dp.primaryaffiliation = 'Student' then 'Student'
    when dp.primaryaffiliation = 'Faculty' then 
      case when daf.edupersonaffiliation = 'Faculty'
        and daf.description = 'Student Faculty' then 'Student'
      else 'Faculty/Staff'
      end
    when dp.primaryaffiliation = 'Staff' then 'Faculty/Staff'
    when dp.primaryaffiliation = 'Employee' then 
      case
        when daf.edupersonaffiliation = 'Employee'
          and daf.description = 'Student Employee' then 'Student'
        when daf.edupersonaffiliation = 'Employee'
          and daf.description = 'Student Faculty' then 'Student'
        else 'Faculty/Staff'
      end
    when dp.primaryaffiliation = 'Officer/Professional' then 'Faculty/Staff'
    when dp.primaryaffiliation = 'Affiliate'
      and daf.edupersonaffiliation = 'Affiliate'
      and daf.description = 'Student Employee' then 'Student'
    when dp.primaryaffiliation = 'Affiliate'
      and daf.edupersonaffiliation = 'Affiliate'
      and daf.description = 'Continuing Ed Non-Credit Student' then 'Student'
    when dp.primaryaffiliation = 'Member'
      and daf.edupersonaffiliation = 'Member'
      and daf.description = 'Faculty' then 'Faculty/Staff'
    else 'Student'
  end as person_type
from dirsvcs.dir_person dp 
  inner join dirsvcs.dir_affiliation daf
    on daf.uuid = dp.uuid
    and daf.campus = 'Boulder Campus' 
    and dp.primaryaffiliation != 'Not currently affiliated'
    and dp.primaryaffiliation != 'Retiree'
    and dp.primaryaffiliation != 'Affiliate'
    and dp.primaryaffiliation != 'Member'
    and daf.description != 'Admitted Student'
    and daf.description != 'Alum'
    and daf.description != 'Confirmed Student' 
    and daf.description != 'Former Student'
    and daf.description != 'Member Spouse'
    and daf.description != 'Sponsored'
    and daf.description != 'Sponsored EFL'
    and daf.description not like 'POI_%'
    and daf.description != 'Retiree'
    and daf.description != 'Boulder3'
  left join dirsvcs.dir_email de
    on de.uuid = dp.uuid
    and de.mail_flag = 'M'
    and de.mail is not null
where (
    dp.primaryaffiliation != 'Student'
    and lower(de.mail) not like '%cu.edu'
  ) or (
    dp.primaryaffiliation = 'Student'
    and exists (
      select 'x' from dirsvcs.dir_acad_career where uuid = dp.uuid
    )
  )
  and de.mail is not NULL
  and lower(de.mail) not like '%cu.edu'
