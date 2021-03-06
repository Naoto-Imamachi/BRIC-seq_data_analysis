#Title: Estimate fitting decay curve
#Auther: Naoto Imamachi
#ver: 1.0.0
#Date: 2015-10-08

###current_directory###
setwd("C:/Users/Naoto/Documents/github/BRIC-seq_data_analysis/BridgeR/data")

###input_file_infor###
hour <- c(0,1,2,4,8,12)
#group <- c("siCTRL","siStealth")
group <- c("siStealth","siPUM1")
#files <- c("C:/Users/Naoto/Documents/github/BRIC-seq_data_analysis/BridgeR/data/siCTRL_genes_RefSeq_result_mRNA.fpkm_table",
#           "C:/Users/Naoto/Documents/github/BRIC-seq_data_analysis/BridgeR/data/siStealth_genes_RefSeq_result_mRNA.fpkm_table")
files <- c("C:/Users/Naoto/Documents/github/BRIC-seq_data_analysis/BridgeR/data/siStealth_genes_RefSeq_result_mRNA.fpkm_table",
           "C:/Users/Naoto/Documents/github/BRIC-seq_data_analysis/BridgeR/data/siPUM1_genes_RefSeq_result_mRNA.fpkm_table")

###Estimate_normalization_factor_function###
BridgeRHalfLifeCalculation <- function(filename = "BridgeR_3_Normalized_expression_data.txt", group, hour, InforColumn = 4, CutoffRelExp = 0.1, CutoffDataPoint = 3, OutputFile = "BridgeR_4_half-life_calculation.txt"){
    ###Import_library###
    library(data.table)
    
    ###Prepare_file_infor###
    time_points <- length(hour)
    group_number <- length(group)
    input_file <- fread(filename, header=T)
    output_file <- OutputFile
    
    ###print_header###
    cat("",file=output_file)
    hour_label <- NULL
    for(a in 1:group_number){
        if(!is.null(hour_label)){
            cat("\t", file=output_file, append=T)
        }
        hour_label <- NULL
        for(x in hour){
            hour_label <- append(hour_label, paste("T", x, "_", a, sep=""))
        }
        infor_st <- 1 + (a - 1)*(time_points + InforColumn)
        infor_ed <- (InforColumn)*a + (a - 1)*time_points
        infor <- colnames(input_file)[infor_st:infor_ed]
        cat(infor,hour_label, sep="\t", file=output_file, append=T)
        cat("\t", sep="", file=output_file, append=T)
        cat("Model","Decay_rate_coef","coef_error","coef_p-value","R2","Adjusted_R2","Residual_standard_error","half_life", sep="\t", file=output_file, append=T)
    }
    cat("\n", sep="", file=output_file, append=T)
    
    ###calc_RNA_half_lives###
    gene_number <- length(input_file[[1]])
    for(x in 1:gene_number){
        data <- as.vector(as.matrix(input_file[x,]))
        for(a in 1:group_number){
            if(a != 1){
                cat("\t", sep="", file=output_file, append=T)
            }
            infor_st <- 1 + (a - 1)*(time_points + InforColumn)
            infor_ed <- (InforColumn)*a + (a - 1)*time_points
            exp_st <- infor_ed + 1
            exp_ed <- infor_ed + time_points
            
            gene_infor <- data[infor_st:infor_ed]
            cat(gene_infor, sep="\t", file=output_file, append=T)
            cat("\t", file=output_file, append=T)
            exp <- as.numeric(data[exp_st:exp_ed])
            cat(exp, sep="\t", file=output_file, append=T)
            cat("\t", file=output_file, append=T)
            time_point_exp <- data.frame(hour,exp)
            time_point_exp <- time_point_exp[time_point_exp$exp >= CutoffRelExp, ]
            data_point <- length(time_point_exp$exp)
            if(!is.null(time_point_exp)){
                if(data_point >= CutoffDataPoint){
                    model <- lm(log(time_point_exp$exp) ~ time_point_exp$hour - 1)
                    model_summary <- summary(model)
                    coef <- -model_summary$coefficients[1]
                    coef_error <- model_summary$coefficients[2]
                    coef_p <- model_summary$coefficients[4]
                    r_squared <- model_summary$r.squared
                    adj_r_squared <- model_summary$adj.r.squared
                    residual_standard_err <- model_summary$sigma
                    half_life <- log(2)/coef
                    #if(coef < 0 || half_life >= 24){
                    #    half_life <- 24
                    #}
                    if(coef < 0){
                        half_life <- Inf
                    }
                    cat("Exponential_Decay_Model",coef,coef_error,coef_p,r_squared,adj_r_squared,residual_standard_err,half_life, sep="\t", file=output_file, append=T)
                }else{
                    cat("few_data","NA","NA","NA","NA","NA","NA","NA", sep="\t", file=output_file, append=T)
                }
            }else{
                cat("low_expresion","NA","NA","NA","NA","NA","NA","NA", sep="\t", file=output_file, append=T)
            }
        }
        cat("\n", file=output_file, append=T)
    }
}

###Test###
#BridgeRHalfLifeCalculation(group=group, hour=hour)
#BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_expression_data_house-keeping_genes.txt", group=group, hour=hour, OutputFile = "BridgeR_4_half-life_calculation_house-keeping_genes.txt")
#BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_expression_data_siStealth_siPUM1.txt", group=group, hour=hour, OutputFile = "BridgeR_4_half-life_calculation_siStealth_siPUM1.txt")

#BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_simulation_data.txt", group=c("Simulation_A"), hour=hour, InforColumn = 1, OutputFile = "BridgeR_4_half-life_calculation_Simulation_A.txt")
#BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_simulation_B_data.txt", group=c("Simulation_B"), hour=hour, InforColumn = 1, OutputFile = "BridgeR_4_half-life_calculation_Simulation_B.txt")
#BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_simulation_C_data.txt", group=c("Simulation_C"), hour=hour, InforColumn = 1, OutputFile = "BridgeR_4_half-life_calculation_Simulation_C.txt")

#BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_simulation_TypeA_data.txt", group=c("Simulation_TypeA"), hour=hour, InforColumn = 1, OutputFile = "BridgeR_4_half-life_calculation_Simulation_TypeA.txt")
#BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_simulation_TypeB_data.txt", group=c("Simulation_TypeB"), hour=hour, InforColumn = 1, OutputFile = "BridgeR_4_half-life_calculation_Simulation_TypeB.txt")
#BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_simulation_TypeC_data.txt", group=c("Simulation_TypeC"), hour=hour, InforColumn = 1, OutputFile = "BridgeR_4_half-life_calculation_Simulation_TypeC.txt")

BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_simulation_Test1_None_data.txt", group=c("Simulation_Test1_None"), hour=hour, InforColumn = 1, OutputFile = "BridgeR_4_half-life_calculation_Simulation_Test1_None.txt")
BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_simulation_Test1_Stable_data.txt", group=c("Simulation_Test1_Stable"), hour=hour, InforColumn = 1, OutputFile = "BridgeR_4_half-life_calculation_Simulation_Test1_Stable.txt")
BridgeRHalfLifeCalculation(filename="BridgeR_3_Normalized_simulation_Test1_Unstable_data.txt", group=c("Simulation_Test1_Unstable"), hour=hour, InforColumn = 1, OutputFile = "BridgeR_4_half-life_calculation_Simulation_Test1_Unstable.txt")
