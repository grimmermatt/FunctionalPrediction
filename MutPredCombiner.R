# MutPredCombiner.R
# Put all raw outputs from Mutation assessor and PROVEAN/SIFT in the same directory, along with MutPredCombiner.R
# Input filenames from the prediction outputs : 
# 	PROVEAN/SIFT : 		SampleID_PROVEAN_result_one.tsv
# 	Mutation Assessor : 	SampleID_sifo+MutAs.txt
# 	eg. SampleID = Patient01

# Usage example : Rscript MutPredCombiner.R Patient01

args <- commandArgs(trailingOnly = TRUE)

# Store sample basename (eg. Patient01)
sample <- args[1]

# Read the PROVEAN/SIFT file
PROVEAN_out <- read.delim(paste(sample,"_PROVEAN_result_one.tsv", sep=""))

# Clean up column naming on the PROVEAN/SIFT data frame
names(PROVEAN_out)[11:16]<-c("PROVEAN_score", "PROVEAN_verdict", "X.SEQ", "X.CLUSTER", "SIFT_score", "SIFT_verdict")

# Extract the PROVEAN/SIFT scores and verdicts
PROVEAN_results <- PROVEAN_out[,c(12,11,16,15)]

# Read the Mutation Assessor output
sifo_MutAs <- read.delim(paste(sample, "sifo+MutAs.txt", sep=""))

# Merge the data frames, adding the PROVEAN/SIFT columns at the end
predictions_merged <- data.frame(sifo_MutAs, PROVEAN_results)

# Export text file of the merged mutation predictions
write.table(predictions_merged, paste(sample, "_predictions_merged.txt", sep=""), sep="\t", row.names=FALSE)
