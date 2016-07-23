Worker.create!([
                 {
                   first_name: 'De Wet',
                   last_name: 'Blomerus',
                   mobile_number: '+27792958514',
                   password: 'secret',
                   password_confirmation: 'secret',
                   confirmed_at: Time.now,
                   role: 'worker',
                   service: 'Other'
                 },
                 {
                   first_name: 'Dillon',
                   last_name: 'Harris',
                   mobile_number: '+27720000002',
                   password: 'secret',
                   password_confirmation: 'secret',
                   confirmed_at: Time.now,
                   role: 'worker',
                   service: 'Gardening'
                 },
                 {
                   first_name: 'Nathaniel',
                   last_name: 'Rhoda',
                   mobile_number: '+27631568522',
                   password: 'secret',
                   password_confirmation: 'secret',
                   confirmed_at: Time.now,
                   role: 'worker',
                   service: 'Building'
                 },
                 {
                   first_name: 'Hangula',
                   last_name: 'Lukas',
                   mobile_number: '+27720000004',
                   password: 'secret',
                   password_confirmation: 'secret',
                   confirmed_at: Time.now,
                   role: 'worker',
                   service: 'Plumbing'
                 },
                 {
                   first_name: 'Aldo',
                   last_name: 'Stevens',
                   mobile_number: '+27720000005',
                   password: 'secret',
                   password_confirmation: 'secret',
                   confirmed_at: Time.now,
                   role: 'worker',
                   service: 'Painting'
                 },
                 {
                   first_name: 'Chukuma',
                   last_name: 'Kingsley',
                   mobile_number: '+27720000006',
                   password: 'secret',
                   password_confirmation: 'secret',
                   confirmed_at: Time.now,
                   role: 'worker',
                   service: 'Painting'
                 },
                 {
                   first_name: 'Christian',
                   last_name: 'Raymond',
                   mobile_number: '+27720000007',
                   password: 'secret',
                   password_confirmation: 'secret',
                   confirmed_at: Time.now,
                   role: 'worker',
                   service: 'Gardening'
                 },
                 {
                   first_name: 'Jeremy',
                   last_name: 'Ramos',
                   mobile_number: '+27720000008',
                   password: 'secret',
                   password_confirmation: 'secret',
                   confirmed_at: Time.now,
                   role: 'worker',
                   service: 'Electical'
                 },
                 {
                   first_name: 'Dillon',
                   last_name: 'Harris',
                   mobile_number: '+27720000009',
                   password: 'secret',
                   password_confirmation: 'secret',
                   confirmed_at: Time.now,
                   role: 'worker',
                   service: 'Pet care'
                 }
               ])

Employer.create!([
               {
                 first_name: 'Marysol',
                 last_name: 'Blomerus',
                 mobile_number: '+27722857438',
                 email: 'marysol@blomerus.org',
                 password: 'secret',
                 password_confirmation: 'secret',
               }
             ])
