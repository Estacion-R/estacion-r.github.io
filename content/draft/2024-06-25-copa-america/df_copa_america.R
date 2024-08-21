
# pak::pak("hypebright/brackets")
library(brackets)

# Round-Robin + knockout stage
df_copa_america <- list(
  participant = list(
    list(id = 0, tournament_id = 0, name = "🇦🇷 Argentina"),
    list(id = 1, tournament_id = 0, name = "🇵🇪 Perú"),
    list(id = 2, tournament_id = 0, name = "🇨🇱 Chile"),
    list(id = 3, tournament_id = 0, name = "🇨🇦 Canada"),
    list(id = 4, tournament_id = 0, name = "🇻🇪 Venezuela"),
    list(id = 5, tournament_id = 0, name = "🇲🇽 México"),
    list(id = 6, tournament_id = 0, name = "🇪🇨 Ecuador"),
    list(id = 7, tournament_id = 0, name = "🇯🇲 Jamaica"),
    list(id = 8, tournament_id = 0, name = "🇺🇾 Uruguay"),
    list(id = 9, tournament_id = 0, name = "🇺🇸 Estados Unidos"),
    list(id = 10, tournament_id = 0, name = "🇵🇦 Panama"),
    list(id = 11, tournament_id = 0, name = "🇧🇴 Bolivia"),
    list(id = 12, tournament_id = 0, name = "🇧🇷 Brasil"),
    list(id = 13, tournament_id = 0, name = "🇨🇴 Colombia"),
    list(id = 14, tournament_id = 0, name = "🇵🇾 Paraguay"),
    list(id = 15, tournament_id = 0, name = "🇨🇷 Costa Rica"),
    list(id = 99, tournament_id = 0, name = "🦫")
    
  ),
  stage = list(
    list(
      id = 0,
      tournament_id = 0,
      name = "Copa América - Fase de grupos ⚽️",
      type = "round_robin",
      number = 0,
      settings = list(
        size = 16,
        grandFinal = "none",
        groupCount = 4,
        roundRobinMode = "simple",
        matchesChildCount = 0
      )
    ),
    list(
      id = 1,
      tournament_id = 0,
      name = "Llaves 🏆",
      type = "single_elimination",
      number = 1,
      settings = list(
        size = 8,
        seedOrdering = list("natural"),
        grandFinal = "simple",
        matchesChildCount = 0
      )
    )
  ),
  group = list(
    list(id = 0, stage_id = 0, number = 1),
    list(id = 1, stage_id = 0, number = 2),
    list(id = 2, stage_id = 0, number = 3),
    list(id = 3, stage_id = 0, number = 4)
  ),
  round = list(
    list(id = 0, number = 1, stage_id = 0, group_id = 0),
    list(id = 1, number = 2, stage_id = 0, group_id = 0),
    list(id = 2, number = 3, stage_id = 0, group_id = 0),
    list(id = 3, number = 4, stage_id = 0, group_id = 0),
    list(id = 4, number = 1, stage_id = 1, group_id = 0),
    list(id = 5, number = 2, stage_id = 1, group_id = 0),
    list(id = 6, number = 3, stage_id = 1, group_id = 0)
  ),
  match = list(
    list( # Argentina - Canada
      id = 0,
      number = 0,
      stage_id = 0,
      group_id = 0,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 0, score = 2, result = "win"),
      opponent2 = list(id = 3, score = 0, result = "loss")
    ),
    list( # Peru - Chile
      id = 1,
      number = 1,
      stage_id = 0,
      group_id = 0,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 1, score = 0, result = "draw"),
      opponent2 = list(id = 2, score = 0, result = "draw")
    ),
    list( # Mexico - Jamaica
      id = 2,
      number = 2,
      stage_id = 0,
      group_id = 1,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 5, score = 1, result = "win"),
      opponent2 = list(id = 7, score = 0, result = "loss")
    ),
    list( # Ecuador - Venezuela
      id = 3,
      number = 3,
      stage_id = 0,
      group_id = 1,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 6, score = 1, result = "loss"),
      opponent2 = list(id = 4, score = 2, result = "win")
    ),
    list( # EEUU - Bolivia
      id = 4,
      number = 4,
      stage_id = 0,
      group_id = 2,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 9, score = 2, result = "win"),
      opponent2 = list(id = 11, score = 0, result = "loss")
    ),
    list( # Uruguay - Panama
      id = 4,
      number = 4,
      stage_id = 0,
      group_id = 2,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 8, score = 3, result = "win"),
      opponent2 = list(id = 10, score = 1, result = "loss")
    ),
    list( # Brasil - Costa rica
      id = 5,
      number = 5,
      stage_id = 0,
      group_id = 3,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 12, score = 0, result = "draw"),
      opponent2 = list(id = 15, score = 0, result = "draw")
    ),
    list( # Colombia - Paraguay
      id = 6,
      number = 6,
      stage_id = 0,
      group_id = 3,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 13, score = 2, result = "win"),
      opponent2 = list(id = 14, score = 1, result = "loss")
    ),
    list(# Chile - Argentina
      id = 7,
      number = 7,
      stage_id = 0,
      group_id = 0,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 2, score = "-", result = ""),
      opponent2 = list(id = 0, score = "-", result = "")
    ),
    list( # Peru - Canada
      id = 8,
      number = 8,
      stage_id = 0,
      group_id = 0,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 1, score = "-", result = ""),
      opponent2 = list(id = 3, score = "-", result = "")
    ),
    list( # Venezuela - Mexico
      id = 9,
      number = 9,
      stage_id = 0,
      group_id = 1,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 4, score = "-", result = ""),
      opponent2 = list(id = 5, score = "-", result = "")
    ),
    list( # Ecuador - Jamaica
      id = 10,
      number = 10,
      stage_id = 0,
      group_id = 1,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 6, score = "-", result = ""),
      opponent2 = list(id = 7, score = "-", result = "")
    ),
    list( # Panama - EEUU
      id = 11,
      number = 11,
      stage_id = 0,
      group_id = 2,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 10, score = "-", result = ""),
      opponent2 = list(id = 9, score = "-", result = "")
    ),
    list( # Uruguay - Bolivia
      id = 12,
      number = 12,
      stage_id = 0,
      group_id = 2,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 8, score = "-", result = ""),
      opponent2 = list(id = 11, score = "-", result = "")
    ),
    list( # Paraguay - Brasil
      id = 13,
      number = 13,
      stage_id = 0,
      group_id = 3,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 14, score = "-", result = ""),
      opponent2 = list(id = 12, score = "-", result = "")
    ),
    list( # Colombia - Costa Rica
      id = 14,
      number = 14,
      stage_id = 0,
      group_id = 3,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 13, score = "-", result = ""),
      opponent2 = list(id = 15, score = "-", result = "")
    ),
    list( # Argentina - Peru
      id = 15,
      number = 15,
      stage_id = 0,
      group_id = 0,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 0, score = "-", result = ""),
      opponent2 = list(id = 1, score = "-", result = "")
    ),
    list( # Canada - Chile
      id = 16,
      number = 16,
      stage_id = 0,
      group_id = 0,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 3, score = "-", result = ""),
      opponent2 = list(id = 2, score = "-", result = "")
    ),
    list( # Mexico - Ecuador
      id = 17,
      number = 17,
      stage_id = 0,
      group_id = 1,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 5, score = "-", result = ""),
      opponent2 = list(id = 6, score = "-", result = "")
    ),
    list( # Jamaica - Venezuela
      id = 18,
      number = 18,
      stage_id = 0,
      group_id = 1,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 7, score = "-", result = ""),
      opponent2 = list(id = 4, score = "-", result = "")
    ),
    list( # EEUU - Uruguay
      id = 19,
      number = 19,
      stage_id = 0,
      group_id = 2,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 9, score = "-", result = ""),
      opponent2 = list(id = 8, score = "-", result = "")
    ),
    list( # Bolivia - Panama
      id = 20,
      number = 20,
      stage_id = 0,
      group_id = 2,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 11, score = "-", result = ""),
      opponent2 = list(id = 10, score = "-", result = "")
    ),
    list( # Brasil - Colombia
      id = 21,
      number = 21,
      stage_id = 0,
      group_id = 3,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 12, score = "-", result = ""),
      opponent2 = list(id = 13, score = "-", result = "")
    ),
    list( # Costa Rica - Paraguay
      id = 22,
      number = 22,
      stage_id = 0,
      group_id = 3,
      round_id = 0,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 15, score = "-", result = ""),
      opponent2 = list(id = 14, score = "-", result = "")
    ),
    list( # Cuartos - 1A vs 2B
      id = 23,
      number = 23,
      stage_id = 1,
      group_id = 0,
      round_id = 4,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 99, score = "-", result = ""),
      opponent2 = list(id = 99, score = "-", result = "")
    ),
    list(
      id = 24,
      number = 24,
      stage_id = 1,
      group_id = 0,
      round_id = 4,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 99, score = "-", result = ""),
      opponent2 = list(id = 99, score = "-", result = "")
    ),
    list(
      id = 25,
      number = 25,
      stage_id = 1,
      group_id = 0,
      round_id = 4,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 99, score = "-", result = ""),
      opponent2 = list(id = 99, score = "-", result = "")
    ),
    list(
      id = 26,
      number = 26,
      stage_id = 1,
      group_id = 0,
      round_id = 4,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 99, score = "-", result = ""),
      opponent2 = list(id = 99, score = "-", result = "")
    ),
    list(
      id = 27,
      number = 27,
      stage_id = 1,
      group_id = 0,
      round_id = 5,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 99, score = "-", result = ""),
      opponent2 = list(id = 99, score = "-", result = "")
    ),
    list(
      id = 28,
      number = 28,
      stage_id = 1,
      group_id = 0,
      round_id = 5,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 99, score = "-", result = ""),
      opponent2 = list(id = 99, score = "-", result = "")
    ),
    list(
      id = 29,
      number = 29,
      stage_id = 1,
      group_id = 0,
      round_id = 6,
      child_count = 0,
      status = 4,
      opponent1 = list(id = 99, score = "-", result = ""),
      opponent2 = list(id = 99, score = "-", result = "")
    )
  ),
  match_game = list()
)

