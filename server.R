
library(shiny)

shinyServer(function(input, output) {

    data_perimetre <- eventReactive(input$appliquer_choix, {
    
        data_perimetre <- data
        
        # Périmètre sur le genre
        if (input$choix_genre != "Tous les genres") {
            data_perimetre <- data_perimetre %>% filter(genre == input$choix_genre) 
        }
        
        # Périmètre sur les années
        data_perimetre <- filter(data_perimetre, annee >= input$choix_annees_min_max[1], annee <= input$choix_annees_min_max[2]) 
        
        # Périmètre sur les nationalites
        if (!is.null(input$choix_nationalites)){
        data_perimetre <- filter(data_perimetre, nationalite %in% input$choix_nationalites) 
        }
        
        # Exclusion des films repris, si précisé
        if (input$choix_exclure_reprises) {
            data_perimetre <- filter(data_perimetre, reprise != TRUE)
        }
        
        data_perimetre
    })
    
    #Visualisation du nombre de films par an
    output$visualisation_nb_films <- renderPlot({

        ggplot(data_perimetre(), aes(x = annee)) + geom_bar(fill = "royal blue") + 
            labs(title = "Evolution du nombre de films",
                 subtitle = paste("Genre : ", input$choix_genre),
                 caption = paste("Films compris entre",input$choix_annees_min_max[1], "et",input$choix_annees_min_max[2]))
    })

    #Visualisation du nombre de films par an
    output$visualisation_nb_films_plotly <- renderPlotly({
        
        data_perimetre() %>% 
            count(annee) %>% 
            plot_ly(y = ~n, x = ~annee, hoverinfo = "text", text = ~paste(n, "films en", annee)) %>%
            add_bars() %>% 
            layout(yaxis = list(title = "Nb films"),
                   title = paste("Evolution du nombre de films entre",input$choix_annees_min_max[1], "et",input$choix_annees_min_max[2]))
    })
    
    
    # Afficher la liste des films 
    output$liste_films <- renderDataTable({
        
        # Variables à afficher dans le tableau
        data_liste <- select(data_perimetre(), titre, annee, genre, note_presse, note_spectateurs)
        
   
        
        # Liste des films à afficher
        data_liste
    })
    
    
    # Liste des films à récupérer
    output$liste_films_csv <- downloadHandler(
        filename = function() {
            paste("films", "_", input$choix_genre, "_", input$choix_annees_min_max[1], "_",input$choix_annees_min_max[2], ".csv", sep="")
        },
        content = function(file) {
            write.csv2(data_perimetre(), file)
        }
    )

    
    
    # Pour le débuggage : afficher une valeur
    debug <- observe({
        print(input$appliquer_choix)
    })   
    
})

