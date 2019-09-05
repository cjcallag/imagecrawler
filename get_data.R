yemen <- stream_tweets(
  c(12.293029, 19.430271, 43.486751, 52.524378),
  timeout = (7200)
)

df <- yemen %>%
  preprocess_df(., "screen_name", "created_at", "ext_media_url")

build_df(df$screen_name, df$created_at, df$ext_media_url) %>%
  DT::datatable()

# nk <- query_tweets(query = "#northkorea",
#                    n     = 5000) 
# saveRDS(nk, file = "data/nk.RDS")
df <- readRDS("data/nk.RDS") %>%
  preprocess_df(., "screen_name", "created_at", "ext_media_url")

build_df(df$screen_name, df$created_at, df$ext_media_url) %>%
  DT::datatable(escape = FALSE)

# nk_1000 <- query_tweets(query = "#northkorea",
#                         n     = 1000)
# saveRDS(nk_1000, file = "data/nk_1000.RDS")
df <- readRDS("data/nk_1000.RDS") %>%
  preprocess_df(., "screen_name", "created_at", "ext_media_url")

build_df(df$screen_name, df$created_at, df$ext_media_url) %>%
  DT::datatable(escape = FALSE, 
                rownames = FALSE,
                filter = "top",
                extensions = 'Buttons', options = list(
                  dom = 'Bfrtip',
                  buttons = c('pdf', 'print')
                )
                )


