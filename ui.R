# Define UI
shinyUI(
  fluidPage(
    theme = shinythemes::shinytheme('yeti'),
    dashboardPage(
        skin = 'purple',
        dashboardHeader(title = 'Opioids in America'),
        dashboardSidebar(
          sidebarMenu(
            actionLink(inputId='ab1', label="Glenna Dunn", 
                          icon = icon("github"), 
                          onclick ="window.open('https://github.com/gcdunn', '_blank')"),
            br(),
            br(),
            menuItem('State Level Analysis', tabName = 'states', icon = icon('map')),
            menuItem('Prescriber Analysis', tabName = 'prescribers', icon = icon('user-md')),
            menuItem('Pareto Effect', tabName = 'pareto', icon = icon('chart-pie')),
            menuItem('Data Sources', tabName = 'data', icon = icon('table'))
          )),
        dashboardBody(
          tabItems(
            tabItem(tabName = 'states',
              title = 'State', status = 'primary', solidHeader = TRUE, width=3,
              h3('State-level analysis of factors contributing to opioid abuse'),
              fluidRow(
                box(
                  title = 'Make selections to view the graph',
                  selectInput('year', 
                    label = 'Year:', 
                    choices = years,
                    selected = '2006'),
                  selectInput("quantity", 
                    label = "Quantity:", 
                    choices = quantities,
                    selected = 'Unemployment')
                ), # close box
                box(
                  valueBoxOutput("info_box",width=12)
                )
          ), #close fluidRow
          fluidRow(
            box(
              title = element_blank(), status = "primary", solidHeader = TRUE,width=40,
              plotOutput("state_plot", height = 500, width = 800)
            )
          )
        ), #close tabItem
        tabItem(tabName = 'prescribers',
                title = 'Prescribers', status = 'primary', solidHeader = TRUE, width=3,
                h3('Prescriber-level analysis of opioid prescriptions'),
                fluidRow(
                  box(
                    title = 'Opioid prescription counts per state ', status = "primary", solidHeader = TRUE,width=40,
                    plotOutput("prescription_plot", height = 500, width = 800)
                  )
                ),
                fluidRow(
                  box(
                    title = 'Male and female opioid prescribers per state', status = "primary", solidHeader = TRUE,width=40,
                    plotOutput("gender_plot", height = 500, width = 800)
                  )
                )
        ), #close tabItem
        tabItem(tabName = 'pareto',
                title = 'Pareto', status = 'primary', solidHeader = TRUE, width=3,
                h3('Family practice and internal medicine providers account for more than 50% of all opioid prescriptions in this dataset.'),
                fluidRow(
                  box(
                    title = element_blank(), status = "primary", solidHeader = TRUE,width=40,
                    plotOutput("pareto_plot", height = 500, width = 800)
                  )
                )
        ), #close tabItem
        tabItem(tabName = 'data',
                title = 'Data', status = 'primary', solidHeader = TRUE, width=3,
                h3('Data Sources'),
                br(),
                cdc <- a('CDC Opioid Overdose Data', href= "https://www.cdc.gov/drugoverdose/data/index.html", target = "_blank"),
                br(),
                census <- a('U.S. Census Bureau Data: Historical Income Tables', href= "https://www.census.gov/data/tables/time-series/demo/income-poverty/historical-income-households.html", target = "_blank"),
                br(),
                bls <- a('Bureau of Labor Statistics', href= "https://www.bls.gov/cps/tables.htm", target = "_blank"),
                br(),
                kaggle <- a('Kaggle', href= "https://www.kaggle.com/apryor6/us-opiate-prescriptions", target = "_blank")
                
        ) #close tabItem
      ) #close tabItems
    ) #close dashboardBody
  ) #close dashboardPage
  ) #close fluidPage
) #close shinyUI
