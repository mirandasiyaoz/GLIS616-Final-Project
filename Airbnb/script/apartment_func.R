house_type <- function(property_df){
  
    house_list<-c()
    i= 1
    
    while(i <= length(property_df)) {
      b <- i
      if(property_df[[i]] == "Apartment"){
        house_list[[i]] <- "Apartment"
      }else if(property_df[[i]] == "Guest suite"){
        house_list[[i]] <- "Guest suite"
      }else if(property_df[[i]] == "Condominium"){
        house_list[[i]] <- "Condominium"
      }else if(property_df[[i]] == "House"){
        house_list[[i]] <- "House"
      }else if(property_df[[i]] == "Guesthouse"){
        house_list[[i]] <- "Guesthouse"
      }else{
        house_list[[i]] <- "Other"
      }
      i=i+1
    }
    house_list
}
