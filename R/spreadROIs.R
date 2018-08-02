#' @name spreadROIs
#' @title Converts the long data format to wide for ROI data
#' @param dat the output from \code{readFileList}
#' @description this function just used tidyverse spread for output specifically from \code{readFileList}
#' only does this for volume and only if you haven't modified the data frame. 
#' should be ok if you select type and level
#' @export
spreadROIs = function(dat){
        out = dat %>% 
            ## This step shouldn't be necessary, add a temporary variable
            ## so that ROI names are unique. For some reason basalForebrain is 
            ## repeated twice in level 5 type 1 and 2. Have emails out to see
            ## if this is an error or if there's some other difference in the 
            ## two basal forebrain measures
            group_by(id) %>%
            mutate(temp = 1 : n()) %>% 
            ungroup() %>% 
            ## If the above ever gets fixed, remove temp from here
            ## This just adds something to make the ROI names unique 
            ## at level 5
            unite(key, roi, type, level, temp,  sep = "_", remove = TRUE) %>%  
            select(-min, -max, -mean, -std) %>% 
            ## Want a unique ICV and TBV per subject. However
            ## I can't figure out any way other than converting the 
            ## numeric values to character then back
            mutate(icv = as.character(icv), tbv = as.character(tbv)) %>% 
            spread(key = key, value = volume) %>%
            mutate(icv = as.numeric(icv), tbv = as.numeric(tbv))
}
