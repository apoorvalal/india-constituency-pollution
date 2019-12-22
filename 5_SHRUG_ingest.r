####################################################
rm(list = ls())
#library(LalRUtils)
library(tidyverse)
library(AER)
library(stargazer)
library(lfe)
library(rio)
library(foreach)
library(magrittr)
library(data.table)
#load_or_install(c("tidyverse", "AER", "stargazer", "lfe",
#  "rio", "foreach", "magrittr", "data.table")) #,  'lib2'))
####################################################
#%%
dbox_root = '~/Dropbox/1_Research/India_Forests/'
#rice_root = '/home/apoorval/Research/GeoSpatial/India_Forests/'
#root = dbox_root
root = '/home/users/asimoes/data/'
data = file.path(root)

root_large = '/scratch/users/asimoes/data/'
data_scratch = file.path(root_large)
setwd(data)
shrug = file.path(data, 'admin/shrug_1')
#%%
list.files(shrug)
list.files(file.path(shrug, 'shrug-v1.1.samosa-keys-csv/'))
#%%
shr_p11_key = fread(file.path(shrug, 'shrug-v1.1.samosa-keys-csv/shrug_pc11r_key.csv'))
shr_p11_key %>% head()
shr_p11_key %>% nrow
#%%
shr_p11_key[, `:=`(
    p_state_id       = sprintf("%02d", pc11_state_id),
    p_district_id    = sprintf("%03d", pc11_district_id),
    p_subdistrict_id = sprintf("%05d", pc11_subdistrict_id),
    p_village_id     = sprintf("%06d", pc11_village_id)
)]
shr_p11_key[,
        CODE_2011 := paste0(p_state_id, p_district_id, p_subdistrict_id, p_village_id)]

shr_p11_key %>% str

treat_status = import(file.path(data_scratch, '/intermediate/19-11-29-villages_points_all_2011.csv'))

treat_status %>% nrow

treat_w_shrid = merge(treat_status, shr_p11_key, on = 'CODE_2011', all = F)

treat_w_shrid %>% nrow

treat_w_shrid %>% head()

vcf_wide = fread(list.files(file.path(shrug, 'shrug-v1.1.samosa-vcf-csv'), full.names=T)[1])

vcf_wide %>% head()

est_samp_vcf = merge(treat_w_shrid , vcf_wide, on = 'shrid', all=F)

est_samp_vcf %>% nrow

fwrite(est_samp_vcf, file.path(data_scratch, 'intermediate/19-12-02-villages_w_vcf_2011.csv'))
