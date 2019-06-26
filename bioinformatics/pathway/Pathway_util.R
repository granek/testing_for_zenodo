get_gset_name_from_id <- function(pathid, mygenesets){
    id <- grep(pathid, names(genesets_cne_h99), value = TRUE)
    return(id)
}

get_gset_lst_from_id <- function(pathid, mygenesets){
    id <- get_gset_name_from_id(pathid, mygenesets)
    return(mygenesets[[id]])
}

get_gset_idx_from_name <- function(pathname, mygenesets){
    pathname_all <- names(mygenesets)
    lst <- lapply(pathname, function(x){
        return( grep(pattern = x, pathname_all, ignore.case = TRUE) )
    })
    idx <- Reduce(f = intersect, x = lst)
    return(idx)
}

ortholog_mapping <- function(vec_num, dat_map, from, to){
    dat <- data.frame(
        id   = names(vec_num),
        value = vec_num)
    colnames(dat) <- c(from, "value")
    dat <- dat %>% 
        left_join(., dat_map, by = from) %>%
        na.omit %>%
        group_by(!!rlang::sym(to)) %>%
        summarize(value = mean(value))
        
    return(dat)
}
 