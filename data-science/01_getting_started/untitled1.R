roll <- function(faces=1:6,number_of_dice=1) {
  probabilities_vector <- c(1/10, 1/10, 1/10, 1/10, 1/10, 1/2)
  dice = sample(faces, number_of_dice, replace=TRUE, prob=probabilities_vector)
  show(dice)
}
