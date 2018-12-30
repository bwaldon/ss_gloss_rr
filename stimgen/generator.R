library(jsonlite)

items <- read.csv("items.csv", header = TRUE)
expr <- read.csv("expr.csv", header = TRUE)
polarities <- c("positive","negative")

stims <- data.frame(matrix(ncol = 11, nrow = 0))
colnames(stims) <- colnames(stims) <- c("id","expr","polarity","list","primetype","setup","question","response","type","truefalse_question","truefalse_answer")

# MAKE LISTS

fileConn<-file("stims.js")
writeLines("",fileConn)
close(fileConn)

for (m in seq(1:14)) {
  listofStims <- data.frame(matrix(ncol = 11, nrow = 0))
  colnames(listofStims) <- colnames(stims) <- c("id","expr","polarity","list","primetype","setup","question","response","type","truefalse_question","truefalse_answer")
  for (n in seq(1:14)) {
    p <- n + m
  #  for (p in c(o, o+2)) {
      stim_id <- toString(items$id[(p %% 14) + 1])
      stim_polarity <- polarities[(n %% 2) + 1]
      stim_expr <- toString(expr$expr[(n %% 7) + 1])
      if(stim_expr != "between") {
        num_expression = paste(toString(expr$expr_print[(n %% 7) + 1]), " ", 
                               toString(items$num[(p %% 14) + 1]))
      } else {
        num_expression = paste(toString(expr$expr_print[(n %% 7) + 1]), " ", 
                               toString(items$n_between[(p %% 14) + 1]), " and ", toString(items$num[(p %% 14) + 1]))
      }
      if (stim_expr == "some") {
        stim_question <- toString(items$question_some[(p %% 14) + 1])
        stim_setup <- gsub("EXPR", "", toString(items$setup[(p %% 14) + 1]))
        if (stim_polarity == "positive") {
          stim_response <- gsub("EXPR", stim_expr, toString(items$response_pos[(p %% 14) + 1]))
          stim_response <- paste("</b>Yes. <b>", stim_response)
        } else {
          stim_response <- gsub("EXPR", stim_expr, toString(items$response_neg[(p %% 14) + 1]))
          stim_response <- paste("</b>No. <b>", stim_response)
        }
      } else if (stim_expr == "any") {
        stim_question <- toString(items$question_any[(p %% 14) + 1])
        stim_setup <- gsub("EXPR", "", toString(items$setup[(p %% 14) + 1]))
        if (stim_polarity == "positive") {
          stim_response <- gsub("EXPR", stim_expr, toString(items$response_pos[(p %% 14) + 1]))
          stim_response <- paste("</b>Yes. <b>", stim_response)
        } else {
          stim_response <- gsub("EXPR", stim_expr, toString(items$response_neg[(p %% 14) + 1]))
          stim_response <- paste("</b>No. <b>", stim_response)
        }
      } else {
        stim_setup <- gsub("EXPR", num_expression, toString(items$setup[(p %% 14) + 1]))
        stim_question <- toString(items$question_primed[(p %% 14) + 1])
        if (stim_polarity == "positive") {
          stim_response <- gsub("EXPR", num_expression, toString(items$response_pos[(p %% 14) + 1]))
          stim_response <- paste("</b>Yes. <b>", stim_response)
        } else {
          stim_response <- gsub("EXPR", num_expression, toString(items$response_neg[(p %% 14) + 1]))
          stim_response <- paste("</b>No. <b>", stim_response)
        }
      }
      listofStims[nrow(listofStims)+1,] <- list(id = stim_id, 
                                                expr = stim_expr,
                                                polarity = stim_polarity, 
                                                list = m,
                                                primetype = "primed",
                                                setup = stim_setup,
                                                question = stim_question,
                                                response = stim_response,
                                                type = "critical",
                                                truefalse_question = "na",
                                                truefalse_answer = "na")
   # }
    }
  listofStims.json <- toJSON(listofStims)
  write(paste("var stims_",m,"_","primed =", toString(listofStims.json),"\n",sep=""), 
             file="stims.js", append = TRUE)
  stims <- rbind(stims, listofStims)
}

# NEUTRAL

for (m in seq(1:14)) {
  listofStims <- data.frame(matrix(ncol = 11, nrow = 0))
  colnames(listofStims) <- colnames(stims) <- c("id","expr","polarity","list","primetype","setup","question","response","type","truefalse_question","truefalse_answer")
  for (n in seq(1:14)) {
    p <- n + m
    #  for (p in c(o, o+2)) {
    stim_id <- toString(items$id[(p %% 14) + 1])
    stim_polarity <- polarities[(n %% 2) + 1]
    stim_expr <- toString(expr$expr[(n %% 7) + 1])
    stim_setup <- gsub("EXPR", "", toString(items$setup[(p %% 14) + 1]))
    stim_question <- toString(items$question_neutral[(p %% 14) + 1])
      if(stim_expr != "between") {
        num_expression = paste(toString(expr$expr_print[(n %% 7) + 1]), " ", 
                               toString(items$num[(p %% 14) + 1]))
      } else {
        num_expression = paste(toString(expr$expr_print[(n %% 7) + 1]), " ", 
                               toString(items$n_between[(p %% 14) + 1]), " and ", toString(items$num[(p %% 14) + 1]))
      }
      if (stim_expr == "some") {
        if (stim_polarity == "positive") {
          stim_response <- gsub("EXPR", stim_expr, toString(items$response_pos[(p %% 14) + 1]))
        } else {
          stim_response <- gsub("EXPR", stim_expr, toString(items$response_neg[(p %% 14) + 1]))
        }
      } else if (stim_expr == "any") {
        if (stim_polarity == "positive") {
          stim_response <- gsub("EXPR", stim_expr, toString(items$response_pos[(p %% 14) + 1]))
        } else {
          stim_response <- gsub("EXPR", stim_expr, toString(items$response_neg[(p %% 14) + 1]))
        }
      } else {
        if (stim_polarity == "positive") {
          stim_response <- gsub("EXPR", num_expression, toString(items$response_pos[(p %% 14) + 1]))
        } else {
          stim_response <- gsub("EXPR", num_expression, toString(items$response_neg[(p %% 14) + 1]))
        }
      }
      listofStims[nrow(listofStims)+1,] <- list(id = stim_id, 
                                                expr = stim_expr,
                                                polarity = stim_polarity, 
                                                list = m,
                                                primetype = "neutral",
                                                setup = stim_setup,
                                                question = stim_question,
                                                response = stim_response,
                                                type = "critical",
                                                truefalse_question = "na",
                                                truefalse_answer = "na")
  #  }
  }
  listofStims.json <- toJSON(listofStims)
  write(paste("var stims_",m,"_","neutral =", toString(listofStims.json),"\n",sep=""), 
        file="stims.js", append = TRUE)
  stims <- rbind(stims, listofStims)
}

write.csv(stims,file="ag.csv")

# MAKE FILLERS

fillers <- read.csv("fillers.csv", header = TRUE)

listofFillers <- data.frame(matrix(ncol = 10, nrow = 0))
colnames(listofFillers) <- c("id","expr","polarity","primetype","setup","question","response","type","truefalse_question","truefalse_answer")

for (m in seq(1:14)) {
  stim_id <- toString(fillers$id[m])
  stim_polarity <- toString(fillers$polarity[m])
  stim_expr <- toString(fillers$expr[m])
  stim_setup <- toString(fillers$setup[m])
  stim_question <- toString(fillers$question[m])
  stim_response <- toString(fillers$response[m])
  stim_primetype <- toString(fillers$primetype[m])  
  stim_truefalse_question <- toString(fillers$truefalse_question[m]) 
  stim_truefalse_answer <- toString(fillers$truefalse_answer[m]) 
  listofFillers[nrow(listofFillers)+1,] <- list(id = stim_id, 
                                              expr = stim_expr,
                                              polarity = stim_polarity, 
                                              primetype = stim_primetype,
                                              setup = stim_setup,
                                              question = stim_question,
                                              response = stim_response,
                                              type = "filler",
                                              truefalse_question = stim_truefalse_question,
                                              truefalse_answer = stim_truefalse_answer)
    }
listofFillers.json <- toJSON(listofFillers) 
fileConn<-file("fillers.js")
writeLines(paste("var fillers = ",listofFillers.json, ""), fileConn)
close(fileConn)

