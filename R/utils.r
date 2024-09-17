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
    id == 2 ~ "pass_inc",
    id == 3 ~ "pass_yds",
    id == 4 ~ "pass_tds",
    id == 5 ~ "pass_yds_every_5",
    id == 6 ~ "pass_yds_every_10",
    id == 7 ~ "pass_yds_every_20",
    id == 8 ~ "pass_yds_every_25",
    id == 9 ~ "pass_yds_every_50",
    id == 10 ~ "pass_yds_every_100",
    id == 11 ~ "pass_cmp_every_5",
    id == 12 ~ "pass_cmp_every_10",
    id == 13 ~ "pass_inc_every_5",
    id == 14 ~ "pass_inc_every_10",
    id == 15 ~ "pass_tds_40_plus_yds",
    id == 16 ~ "pass_tds_50_plus_yds",
    id == 17 ~ "pass_yds_300_399",
    id == 18 ~ "pass_yds_400_plus",
    id == 19 ~ "pass_2pt",
    id == 20 ~ "pass_int",
    id == 21 ~ "pass_cmp_pct",
    id == 22 ~ "pass_yds_per_game",

    # rushing
    id == 23 ~ "rush_att",
    id == 24 ~ "rush_yds",
    id == 25 ~ "rush_tds",
    id == 26 ~ "rush_2pt",
    id == 27 ~ "rush_yds_every_5",
    id == 28 ~ "rush_yds_every_10",
    id == 29 ~ "rush_yds_every_20",
    id == 30 ~ "rush_yds_every_25",
    id == 31 ~ "rush_yds_every_50",
    id == 32 ~ "rush_yds_every_100",
    id == 33 ~ "rush_att_every_5",
    id == 34 ~ "rush_att_every_10",
    id == 35 ~ "rush_td_40_plus_yds",
    id == 36 ~ "rush_td_50_plus_yds",
    id == 37 ~ "rush_yds_100_199",
    id == 38 ~ "rush_yds_200_plus",
    id == 39 ~ "rush_yds_per_att",
    id == 40 ~ "rush_yds_per_game",

    # receptions
    id == 41 ~ "rec_cmps",
    id == 42 ~ "rec_yds",
    id == 43 ~ "rec_tds",
    id == 44 ~ "rec_2pt",
    id == 45 ~ "rec_td_40_plus_yds",
    id == 46 ~ "rec_td_50_plus_yds",
    id == 47 ~ "rec_yds_every_5",
    id == 48 ~ "rec_yds_every_10",
    id == 49 ~ "rec_yds_every_20",
    id == 50 ~ "rec_yds_every_25",
    id == 51 ~ "rec_yds_every_50",
    id == 52 ~ "rec_yds_every_100",
    id == 53 ~ "rec_cmp",
    id == 54 ~ "rec_cmp_every_5",
    id == 55 ~ "rec_cmp_every_10",
    id == 56 ~ "rec_yds_100_199",
    id == 57 ~ "rec_yds_200_plus",
    id == 58 ~ "rec_tgt",
    id == 59 ~ "rec_yac",
    id == 60 ~ "rec_ypc",
    id == 61 ~ "rec_yds_per_game",

    # misc
    id == 62 ~ "2pt",
    id == 63 ~ "fumbles_ret_tds",
    id == 64 ~ "sacked",
    id == 65 ~ "fumbles_pass",
    id == 66 ~ "fumbles_rush",
    id == 67 ~ "fumbles_rec",
    id == 68 ~ "fumbles",
    id == 69 ~ "fumbles_pass_lost",
    id == 70 ~ "fumbles_rush_lost",
    id == 71 ~ "fumbles_rec_lost",
    id == 72 ~ "fumbles_lost",
    id == 73 ~ "turnovers",

    # kicking
    id == 74 ~ "fg_cmp_50_plus",
    id == 75 ~ "fg_att_50_plus",
    id == 76 ~ "fg_miss_50_plus",
    id == 77 ~ "fg_cmp_40_49",
    id == 78 ~ "fg_att_40_49",
    id == 79 ~ "fg_miss_40_49",
    id == 80 ~ "fg_cmp_0_39",
    id == 81 ~ "fg_att_0_39",
    id == 82 ~ "fg_miss_0_39",
    id == 83 ~ "fg_cmp_tot",
    id == 84 ~ "fg_att_tot",
    id == 85 ~ "fg_miss_tot",
    id == 86 ~ "fg_cmp_xp",
    id == 87 ~ "fg_att_xp",
    id == 88 ~ "fg_miss_xp",

    # defense
    id == 89 ~ "def_pts_against_0",
    id == 90 ~ "def_pts_against_1_6",
    id == 91 ~ "def_pts_against_7_13",
    id == 92 ~ "def_pts_against_14_17",
    id == 93 ~ "def_block_ret_tds",
    id == 94 ~ "def_fumble_or_int_ret_tds",
    id == 95 ~ "def_ints",
    id == 96 ~ "def_fumbles_recovered",
    id == 97 ~ "def_blocks",
    id == 98 ~ "def_safeties",
    id == 99 ~ "def_sacks",
    id == 100 ~ "def_half_sacks",
    id == 101 ~ "special_kick_ret_tds",
    id == 102 ~ "special_punt_ret_tds",
    id == 103 ~ "def_int_ret_tds",
    id == 104 ~ "def_fumbles_ret_tds",
    id == 105 ~ "def_tds",
    id == 106 ~ "def_fumbles_forced",
    id == 107 ~ "def_tackles_assisted",
    id == 108 ~ "def_tackles_solo",
    id == 109 ~ "def_tackles_total",
    id == 110 ~ "def_tackles_total_every_3",
    id == 111 ~ "def_tackles_total_every_5",
    id == 112 ~ "def_stuffs",
    id == 113 ~ "def_passes_defended",
    id == 114 ~ "special_kick_ret_yds",
    id == 115 ~ "special_punt_ret_yds",
    id == 116 ~ "special_kick_ret_yds_every_10",
    id == 117 ~ "special_kick_ret_yds_every_25",
    id == 118 ~ "special_punt_ret_yds_every_10",
    id == 119 ~ "special_punt_ret_yds_every_25",
    id == 120 ~ "def_pts_against",
    id == 121 ~ "def_pts_against_18_21",
    id == 122 ~ "def_pts_against_22_27",
    id == 123 ~ "def_pts_against_28_34",
    id == 124 ~ "def_pts_against_35_45",
    id == 125 ~ "def_pts_against_46_plus",
    id == 126 ~ "def_pts_against_per_game",
    id == 127 ~ "def_yds_against",
    id == 128 ~ "def_yds_against_minus_99",
    id == 129 ~ "def_yds_against_100_199",
    id == 130 ~ "def_yds_against_200_299",
    id == 131 ~ "def_yds_against_300_349",
    id == 132 ~ "def_yds_against_350_399",
    id == 133 ~ "def_yds_against_400_449",
    id == 134 ~ "def_yds_against_450_499",
    id == 135 ~ "def_yds_against_500_549",
    id == 136 ~ "def_yds_against_550_plus",
    id == 137 ~ "def_yds_against_per_game",

    # punts
    id == 138 ~ "punts",
    id == 139 ~ "punts_yds",
    id == 140 ~ "punts_inside_10",
    id == 141 ~ "punts_inside_20",
    id == 142 ~ "punts_blocked",
    id == 143 ~ "punts_returned",
    id == 144 ~ "punts_return_yds",
    id == 145 ~ "punts_touchbacks",
    id == 146 ~ "punts_fair_catches",
    id == 147 ~ "punts_avg",
    id == 148 ~ "punts_avg_44_plus",
    id == 149 ~ "punts_avg_42_44",
    id == 150 ~ "punts_avg_40_42",
    id == 151 ~ "punts_avg_38_40",
    id == 152 ~ "punts_avg_36_38",
    id == 153 ~ "punts_avg_34_36",
    id == 154 ~ "punts_avg_minus_34",

    # misc
    id == 155 ~ "team_win",
    id == 156 ~ "team_loss",
    id == 157 ~ "team_tie",
    id == 158 ~ "team_points_scored",
    id == 159 ~ "team_points_scored_per_game",
    id == 160 ~ "team_margin_of_victory",
    id == 161 ~ "team_margin_win_25_plus",
    id == 162 ~ "team_margin_win_20_24",
    id == 163 ~ "team_margin_win_15_19",
    id == 164 ~ "team_margin_win_10_14",
    id == 165 ~ "team_margin_win_5_9",
    id == 166 ~ "team_margin_win_1_4",
    id == 167 ~ "team_margin_loss_1_4",
    id == 168 ~ "team_margin_loss_5_9",
    id == 169 ~ "team_margin_loss_10_14",
    id == 170 ~ "team_margin_loss_15_19",
    id == 171 ~ "team_margin_loss_20_24",
    id == 172 ~ "team_margin_loss_25_plus",
    id == 173 ~ "team_margin_of_victory_per_game",
    id == 174 ~ "team_win_pct",

    # bonus
    id == 175 ~ "bonus_td_pass_yds_0_9",
    id == 176 ~ "bonus_td_pass_yds_10_19",
    id == 177 ~ "bonus_td_pass_yds_20_29",
    id == 178 ~ "bonus_td_pass_yds_30_39",
    id == 179 ~ "bonus_td_rush_yds_0_9",
    id == 180 ~ "bonus_td_rush_yds_10_19",
    id == 181 ~ "bonus_td_rush_yds_20_29",
    id == 182 ~ "bonus_td_rush_yds_30_39",
    id == 183 ~ "bonus_td_rec_yds_0_9",
    id == 184 ~ "bonus_td_rec_yds_10_19",
    id == 185 ~ "bonus_td_rec_yds_20_29",
    id == 186 ~ "bonus_td_rec_yds_30_39",

    # more misc
    id == 187 ~ "dst_pts_against",
    id == 188 ~ "dst_pts_against_0",
    id == 189 ~ "dst_pts_against_1_6",
    id == 190 ~ "dst_pts_against_7_13",
    id == 191 ~ "dst_pts_against_14_17",
    id == 192 ~ "dst_pts_against_18_21",
    id == 193 ~ "dst_pts_against_22_27",
    id == 194 ~ "dst_pts_against_28_34",
    id == 195 ~ "dst_pts_against_35_45",
    id == 196 ~ "dst_pts_against_46_plus",
    id == 197 ~ "dst_pts_against_per_game",

    id == 198 ~ "fg_cmp_50_59",
    id == 199 ~ "fg_att_50_59",
    id == 200 ~ "fg_miss_50_59",
    id == 201 ~ "fg_cmp_60_plus",
    id == 202 ~ "fg_att_60_plus",
    id == 203 ~ "fg_miss_60_plus",

    id == 204 ~ "off_ret_2pt",
    id == 205 ~ "def_ret_2pt",
    id == 206 ~ "team_ret_2pt",
    id == 207 ~ "off_safety_1pt",
    id == 208 ~ "def_safety_1pt",
    id == 209 ~ "team_safety_1pt",

    id == 210 ~ "games",

    id == 211 ~ "pass_1st_down",
    id == 212 ~ "rush_1st_down",
    id == 213 ~ "rec_1st_down",

    id == 214 ~ "fg_cmp_yds",
    id == 215 ~ "fg_miss_yds",
    id == 216 ~ "fg_att_yds",
    id == 217 ~ "fg_cmp_yds_every_5",
    id == 218 ~ "fg_cmp_yds_every_10",
    id == 219 ~ "fg_cmp_yds_every_20",
    id == 220 ~ "fg_cmp_yds_every_25",
    id == 221 ~ "fg_cmp_yds_every_50",
    id == 222 ~ "fg_cmp_yds_every_100",
    id == 223 ~ "fg_miss_yds_every_5",
    id == 224 ~ "fg_miss_yds_every_10",
    id == 225 ~ "fg_miss_yds_every_20",
    id == 226 ~ "fg_miss_yds_every_25",
    id == 227 ~ "fg_miss_yds_every_50",
    id == 228 ~ "fg_miss_yds_every_100",
    id == 229 ~ "fg_att_yds_every_5",
    id == 230 ~ "fg_att_yds_every_10",
    id == 231 ~ "fg_att_yds_every_20",
    id == 232 ~ "fg_att_yds_every_25",
    id == 233 ~ "fg_att_yds_every_50",
    id == 234 ~ "fg_att_yds_every_100",

    TRUE ~ paste0("stat_", id)
  )
}

pos_id_to_name <- function(x) {
  dplyr::case_when(
    x == 1 ~ "QB",
    x == 2 ~ "RB",
    x == 3 ~ "WR",
    x == 4 ~ "TE",
    x == 5 ~ "K",
    x == 7 ~ "P",
    x == 9 ~ "DT",
    x == 10 ~ "DE",
    x == 11 ~ "LB",
    x == 12 ~ "CB",
    x == 13 ~ "S",
    x == 14 ~ "HC",
    x == 16 ~ "DST",
    TRUE ~ paste0("pos_", x)
  )
}

slot_names <- c("QB", "TQB", "RB", "RB/WR", "WR", "WR/TE", "TE", "OP",
                 "DT", "DE", "LB", "DL", "CB", "S", "DB", "DP", "DST",
                 "K", "P", "HC", "BE", "IR", "FLEX", "EDR", "Rookie")

slot_name_to_id <- function(x) {
  # QB: 0, RB: 2, WR: 4, TE: 6, DST: 16, K: 17
  dplyr::case_when(
    x == "QB" ~ 0L,
    x == "TQB" ~ 1L, # team quarterback
    x == "RB" ~ 2L,
    x == "RB/WR" ~ 3L,
    x == "WR" ~ 4L,
    x == "WR/TE" ~ 5L,
    x == "TE" ~ 6L,
    x == "OP" ~ 7L, # offensive player
    x == "DT" ~ 8L,
    x == "DE" ~ 9L,
    x == "LB" ~ 10L,
    x == "DL" ~ 11L,
    x == "CB" ~ 12L,
    x == "S" ~ 13L,
    x == "DB" ~ 14L,
    x == "DP" ~ 15L, # defensive player
    x == "DST" ~ 16L,
    x == "K" ~ 17L,
    x == "P" ~ 18L,
    x == "HC" ~ 19L, # head coach
    x == "BE" ~ 20L,
    x == "IR" ~ 21L,
    x == "" ~ 22L,
    x == "FLEX" ~ 23L,
    x == "EDR" ~ 24L, # edge rusher
    x == "Rookie" ~ 25L,
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
    x == 7 ~ "OP", # offensive player
    x == 8 ~ "DT",
    x == 9 ~ "DE",
    x == 10 ~ "LB",
    x == 11 ~ "DL",
    x == 12 ~ "CB",
    x == 13 ~ "S",
    x == 14 ~ "DB",
    x == 15 ~ "DP", # defensive player
    x == 16 ~ "DST",
    x == 17 ~ "K",
    x == 18 ~ "P",
    x == 19 ~ "HC", # head coach
    x == 20 ~ "BE",
    x == 21 ~ "IR",
    x == 22 ~ "",
    x == 23 ~ "FLEX",
    x == 24 ~ "EDR", # edge rusher,
    x == 25 ~ "Rookie",
    TRUE ~ paste0("slot_", x)
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

replace_null <- function(x, replace) {
  is_missing <- purrr::map_lgl(x, is.null)
  x[is_missing] <- replace
  x
}
