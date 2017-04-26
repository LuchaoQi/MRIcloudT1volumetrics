#' @name readFileList 
#' @title A function for readding a list of T1 volumetric mricloud data
#' @param fileList a textlist of files 
#' @param levelList an optional list of levels to include, needs equal length as \code{typeList}
#' @param typeList an optional list of types to include, needs equal length to \code{levelList}
#' @description A function for reading in a collection of files of T1 volumetric output
#' from MRIcloud. The files must be a list of files


readFileList = function(fileList, levelList = 5, typeList = 1){
    if (length(levelList) != length(typeList)) stop("levelList and typeList must have equal length")
    rval = NULL
    for  (i in 1 : length(fileList)){
        f = fileList[i]
        tempDat = readSubject(f) %>%
            subject2df() %>% 
            filter(level %in% levelList, type %in% typeList) %>%
            mutate(id = i)
        rval = rbind(rval, tempDat)
    }
    rval
}