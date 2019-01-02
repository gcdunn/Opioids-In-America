shinyServer(function(input, output) {
  
  output$state_plot <- renderPlot({
    data <- state_stats %>% 
      filter(Year == input$year) %>%
      select(State,Abbrev,input$quantity) %>%
      arrange_(input$quantity)
    quantity <- case_when(
      input$quantity == 'MHI' ~ 'Median Household Income',
      input$quantity == 'Unemployment' ~ 'Unemployment rate',
      input$quantity == 'RxPer100' ~ 'Opioid prescription rate per 100 people',
      input$quantity == 'DeathsPer100k' ~ 'Opioid-related death rate per 100,000 people',
      TRUE ~ ""
    )
    
    ggplot(data, aes_string(x='Abbrev',y=colnames(data)[3])) + geom_bar(stat='identity',fill='#8e82fe') +
      xlab('State') + ylab(quantity) + theme_minimal()
  })
  
  output$info_box <- renderInfoBox({
    data <- state_stats %>% 
      filter(Year == input$year) %>%
      select(State,Abbrev,input$quantity) %>% 
      arrange_(input$quantity)
    quantity <- case_when(
      input$quantity == 'MHI' ~ 'lowest median household income',
      input$quantity == 'Unemployment' ~ 'highest unemployment rate',
      input$quantity == 'RxPer100' ~ 'highest opioid prescription rate per 100 people',
      input$quantity == 'DeathsPer100k' ~ 'highest opioid-related death rate per 100,000 people',
      TRUE ~ ""
    )
    i <- case_when(
      input$quantity == 'MHI' ~ 1,
      TRUE ~ 50
    )
    valueBox(data$State[i],
             paste0('had the ', quantity, ' in ',input$year,'.'),
             color = "purple"
    )
  })
  
  output$prescription_plot <- renderPlot({
    ggplot(opioids_prescribed, aes(x=reorder(Drug,value), y=value,fill=Drug)) +
      geom_bar(stat="identity") +
      xlab('Opiate Drug') +
      ylab('Prescription Count') +
      theme(text = element_text(size=20), axis.text.x = element_text(angle = 45, hjust = 1))
  })
  output$gender_plot <- renderPlot({
    opioid_prescribers_by_state <- opioid_prescribers %>% group_by(State,Gender) %>%
      summarize(Prescriber_Count = n())
    
    ggplot(opioid_prescribers_by_state, aes(x=reorder(State,Prescriber_Count), y=Prescriber_Count, fill=Gender)) + 
      geom_bar(stat="identity") + theme_minimal() +
      xlab('State') + ylab('Number of Opioid Prescribers')
  })
  
  output$pareto_plot <- renderPlot({
    prescribers_pareto <- prescribers_w_opioids %>% gather(key=drug, value=count, c(4:14)) %>%
      group_by(Specialty) %>% mutate(total = sum(count)) %>% ungroup() %>% select(Specialty,total) %>%
      unique() %>% arrange(desc(total)) %>% mutate(ctot = cumsum(total), freq = total/sum(total), cfreq = cumsum(freq)) %>%
      slice(1:20)
    
    ggplot(prescribers_pareto, aes(x=reorder(Specialty,-total))) +
      geom_bar(aes(y=prescribers_pareto$freq), fill='blue', stat="identity") +
      geom_point(aes(y=prescribers_pareto$cfreq), color = rgb(0, 1, 0), pch=16, size=1) +
      geom_path(aes(y=prescribers_pareto$cfreq, group=1), colour="slateblue1", lty=3, size=0.9) +
      theme(text = element_text(size=20),axis.text.x = element_text(angle=90, vjust=0.6)) +
      labs(x='Specialty',y='Percent of Opioid Prescriptions')
  })
  
})


