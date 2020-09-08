is_scalar <- function(x) identical(length(x), 1L)

list_to_dt <- function(x) {
  x <- vapply(x, function(d) if (is.null(d)) NA_real_ else d/1000, double(1L))
  as.POSIXct(x, origin = "1970-01-01", tz = "America/New_York")
}

team_id_to_name <- function(id) {
  rows <- purrr::map_int(id, function(x) {
    matches <- x == team_ids$id
    if (any(matches)) which(matches)[1]
    else NA_integer_
  })

  team_ids$name[rows]
}

team_name_to_id <- function(name) {
  rows <- purrr::map_int(name, function(x) {
    matches <- x == team_ids$name
    if (any(matches)) which(matches)[1]
    else NA_integer_
  })

  team_ids$id[rows]
}

stat_id_to_name <- function(id) {
  dplyr::case_when(
    # passing
    id == 0 ~ "pass_att",
    id == 1 ~ "pass_cmp",
    id == 3 ~ "pass_yds",
    id == 4 ~ "pass_tds",
    id == 19 ~ "pass_2pt",
    id == 20 ~ "pass_int",

    # rushing
    id == 23 ~ "rush_att",
    id == 24 ~ "rush_yds",
    id == 25 ~ "rush_tds",
    id == 26 ~ "rush_2pt",

    # receptions
    id == 42 ~ "rec_yds",
    id == 43 ~ "rec_tds",
    id == 44 ~ "rec_2pt",
    id == 53 ~ "rec_cmp",
    id == 58 ~ "rec_tgt",

    # misc
    id == 64 ~ "sacked",
    id == 72 ~ "fumbles",

    # kicking
    id == 74 ~ "fg_cmp_50",
    id == 75 ~ "fg_att_50",
    #id == 76 ~ "fg_miss_50",
    id == 77 ~ "fg_cmp_40_49",
    id == 78 ~ "fg_att_40_49",
    # id == 79 ~ "fg_miss_40_49"
    id == 80 ~ "fg_cmp_1_39",
    id == 81 ~ "fg_att_1_39",
    #id == 82 ~ "fg_miss_1_39"
    id == 83 ~ "fg_cmp_tot",
    id == 84 ~ "fg_att_tot",
    # id == 85 ~ "fg_miss_tot",
    id == 86 ~ "fg_cmp_xp",
    id == 87 ~ "fg_att_xp",
    # id == 88 ~ "fg_miss_xp"

    # defense
    id == 89 ~ "def_pts_against_0",
    id == 90 ~ "def_pts_against_1_6",
    id == 91 ~ "def_pts_against_7_13",
    id == 92 ~ "def_pts_against_14_17",
    id == 93 ~ "def_block_ret_tds",
    id == 95 ~ "def_ints",
    id == 96 ~ "def_fumbles_recovered",
    id == 97 ~ "def_blocks",
    id == 98 ~ "def_safeties",
    id == 99 ~ "def_sacks",
    id == 101 ~ "special_kick_ret_tds",
    id == 102 ~ "special_punt_ret_tds",
    id == 103 ~ "def_fumble_ret_tds",
    id == 104 ~ "def_int_ret_tds",
    id == 105 ~ "def_tds",
    id == 106 ~ "def_fumbles_forced",
    id == 120 ~ "def_pts_against",
    id == 121 ~ "def_pts_against_18_20",
    id == 122 ~ "def_pts_against_21_27",
    id == 123 ~ "def_pts_against_28_34",
    id == 124 ~ "def_pts_against_35_45",
    id == 125 ~ "def_pts_against_46_plus",
    id == 127 ~ "def_yds_against",
    TRUE ~ paste0("unknown_", id)
  )
}

pos_id_to_name <- function(x) {
  dplyr::case_when(
    x == 1 ~ "QB",
    x == 2 ~ "RB",
    x == 3 ~ "WR",
    x == 4 ~ "TE",
    x == 5 ~ "K",
    x == 9 ~ "FB", # actually its fullback FB
    x == 16 ~ "DST",
    TRUE ~ paste0("unknown_", x)
  )
}

slot_name_to_id <- function(x) {
  # QB: 0, RB: 2, WR: 4, TE: 6, DST: 16, K: 17
  dplyr::case_when(
    x == "QB" ~ 0L,
    x == "RB" ~ 2L,
    x == "WR" ~ 4L,
    x == "TE" ~ 6L,
    x == "DST" ~ 16L,
    x == "K" ~ 17L,
    x == "DT" ~ 8L,
    x == "DE" ~ 9L,
    x == "LB" ~ 10L,
    x == "CB" ~ 11L,
    x == "S" ~ 12L,
    x == "DB" ~ 13L,
    TRUE ~ NA_integer_
  )
}

#' Slot Ids to Name
#'
#' @param x slot id
#'
#' @references {
#' \url{https://support.espn.com/hc/en-us/articles/115003939432-Roster-Slots-Offense-}
#' }
slot_id_to_name <- function(x) {
  x <- as.numeric(x)
  dplyr::case_when(
    x == 0 ~ "QB",
    x == 1 ~ "TQB", # team quarterback
    x == 2 ~ "RB",
    x == 3 ~ "RB/WR",
    x == 4 ~ "WR",
    x == 5 ~ "WR/TE",
    x == 6 ~ "TE",
    x == 7 ~ "QB/RB/WR/TE", # offensive utilty?
    x == 8 ~ "DT",
    x == 9 ~ "DE",
    x == 10 ~ "LB",
    x == 11 ~ "CB",
    x == 12 ~ "S",
    x == 13 ~ "DB",
    x == 14 ~ "DUTIL", # defense utility
    x == 15 ~ "ER", # edge rusher
    x == 16 ~ "DST",
    x == 17 ~ "K",
    x == 20 ~ "QB/RB/WR/TE/K", # offensive utilyFB, K, QB, RB, TE, WR
    #x == 21 ~ "QB/RB/WR/TE/K",
    x == 23 ~ "RB/WR/TE",
    #x == 25 ~ "QB/RB/WR/TE/K",

    TRUE ~ paste0("unknown_", x)
  )
}

camel_to_snake <- function(x) {
  tolower(gsub("(?<!^)(?=[A-Z])", "_", x, perl = TRUE))
}

as_tibble_snake <- function(x) {
  df <- tibble::as_tibble(x)
  colnames(df) <- camel_to_snake(colnames(df))
  df
}
