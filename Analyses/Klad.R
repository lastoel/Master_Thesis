#KLAD


### X_matrix for factor variables with levels

X_matrix <- step1_dat %>% 
  mutate(constant = 1, #add column to be multiplied by intercept
         ISCEDL3 = ISCEDL, #add column for one level of ISCEDL
         HISCED1 = HISCED, #add columns for the levels of HISCED
         HISCED2 = HISCED,
         HISCED3 = HISCED,
         HISCED4 = HISCED,
         HISCED5 = HISCED,
         HISCED6 = HISCED) %>% 
  dplyr::select(constant, ESCS, GRADE, ISCEDL3, HISCED1, HISCED2, HISCED3, HISCED4, HISCED5, HISCED6) %>% #select intercept + Xvars
  t() %>% #transpose to fit posterior object (col = pupils, row = vars)
  as.matrix() #store as matrix