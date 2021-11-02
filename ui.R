

library(shiny)


shinyUI(fluidPage(

    
    navbarPage("Suivi des films allociné",  
               
        tabPanel("Suivi",
    
            # Titre de l'application
            #titlePanel("Suivi des films allociné"), 
            
            # Sélection d'un thème
            #themeSelector() ,
            
            # Utilisation d'un thème
            theme = shinytheme("journal"),
            
            
            
            # Affichage du logo
            
            img(src='logo_allocine.png', align = "middle", height = 80),
        

        
            sidebarLayout(
                
                # Barre latérale
                sidebarPanel(   
                    
                    # Sélection des années
                    sliderInput("choix_annees_min_max",
                                "Films des années...",
                                min = 1990, max = 2017, value = c(1990,2017), sep = ""),
                    
                    # Sélection du genre de film
                    selectInput("choix_genre", "Genre de film", choice = c("Tous les genres", unique(data$genre))),
                    
                    checkboxInput("choix_exclure_reprises", "Exclure les films repris", value = FALSE),
                    selectInput("choix_nationalites", "Inclure seulement certaines nationalites", choice = c(unique(data$nationalite)), multiple = TRUE),
                    actionButton("appliquer_choix", "Appliquer")
                ),
        
                # Fenêtre principale
                mainPanel(
                   tabsetPanel(
                       tabPanel("Evolution du nombre de films",
                                #plotOutput("visualisation_nb_films"),
                                plotlyOutput("visualisation_nb_films_plotly")),
                       tabPanel("Liste des films", dataTableOutput("liste_films"), 
                                downloadButton("liste_films_csv", "Télécharger")
                                )
                   ) # Fin tabsetPanel
                    
                ) # Fin MainPanel
            ) # Fin Layout
        
        ), # Fin panel
        
        tabPanel("A propos", 
                 h1("Application Shiny"),
                 "Exemple d'application réalisée par ", strong("Antoine GIRARD"), br(), em("Décembre 2020"))
    ) # Fin navbarpage
    
)) # Fin UI et fluidpage
