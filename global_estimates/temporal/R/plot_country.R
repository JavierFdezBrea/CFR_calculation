#plot time varying cfr for a country
plot_country <- function(plot_data){

  # get timeseries with the expectation, lower, and upper bounds of true CFR
  expectation <- get_one_timeseries(cCFRBaseline, plot_data)*100
  lower <- get_one_timeseries(cCFREstimateRange[1], plot_data)*100
  upper <- get_one_timeseries(cCFREstimateRange[2], plot_data)*100

  estimate <- expectation$estimate
  ci_poly <- tibble::tibble(x = c(plot_data$date, rev(plot_data$date)),
                            y = c(upper$upper, rev(lower$lower)))

  # clip all of these to (0, 1]
  estimate <- pmin(estimate, 100)
  ci_poly$y <- pmin(ci_poly$y, 100)
  
  p <- plot_data %>% 
    ggplot2::ggplot() +
    ggplot2::theme_bw() + 
    #ggplot2::geom_point(aes(x = date, y = reporting_estimate), size = 0.2) + 
    #ggplot2::geom_path(aes(x = date, y = estimate), colour = 'red', size = 0.3) +
    ggplot2::geom_polygon(data = ci_poly, ggplot2::aes(x = x, y = y), fill = viridis::viridis_pal()(10)[6], alpha = 0.3) +
    ggplot2::coord_cartesian(ylim = c(0, 100)) +
    ggplot2::ylab("") +
    ggplot2::ggtitle(gsub("_", " ", plot_data$country %>% unique())) +
    cfr_plot_theme()
  
  return(p)
}

