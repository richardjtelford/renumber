
#' renumbers files and directories
#' @description Numbered files help the user workout the order in which files should be used. This function makes it easy to number or renumber files with a gadget.
#' @param path path to renumber. Defaults to working directory.
#' @param number_dir Logical. If TRUE, directories will be renumbered, otherwise files.
#' @param prefix Anything to go before the number. Defaults to an empty string.
#' @param postfix What to go after the number. Defaults to a hyphen
#' @param old_prefix Any previous numbering system that should be renumbered.
#' @param test_only If TRUE will output data.frame showing changes that would be made. Files will be untouched.
#' @examples
#' \donttest{
#' #number files
#' renumber(path = ".", number_dir = FALSE, test_only = TRUE)
#' #remove prefix from directories and add new numbers
#' renumber(path = "inst/tutorials", number_dir = TRUE,  test_only = TRUE, old_prefix = "\\d+-")
#' }
#' @importFrom sortable add_rank_list bucket_list
#' @importFrom shiny fluidRow observeEvent renderPrint verbatimTextOutput runGadget stopApp column
#' @importFrom stringr str_remove str_pad
#' @importFrom miniUI miniPage gadgetTitleBar miniContentPanel
#' @importFrom htmltools tags HTML
#' @export
#'
renumber <- function(path = ".", number_dir = TRUE, prefix = "", postfix = "-", old_prefix = "", test_only = FALSE){
  to_rename <- if(isTRUE(number_dir)) {
    list.dirs(path, recursive = FALSE)
  } else{
    list.files(path, recursive = FALSE)
  }

  process <- function(str, prefix, post_fix, old_prefix){
    #remove any old prefix
    str <- str_remove(str, paste0("^", old_prefix))
    #add new prefix
    numbers <- str_pad(string = 1:length(str), width = max(nchar(1:length(str))),pad = 0)
    str <- paste0(prefix, numbers, postfix, str)
    str
  }

    ui <- miniPage(
      gadgetTitleBar("Renumber"),
      miniContentPanel(
      tags$head(
        tags$style(HTML(".bucket-list-container {min-height: 350px;}"))
      ),
      fluidRow(
        column(
          tags$b("Input"),
          width = 12,
          bucket_list(
            header = "Drag items to sort or not number",
            group_name = "bucket_list_group",
            orientation = "horizontal",
            add_rank_list(
              text = "Number these",
              labels = basename(to_rename),
              input_id = "rank_list_1"
            ),
            add_rank_list(
              text = "Don't number",
              labels = NULL,
              input_id = "rank_list_2"
            )
          )
        )
      ),
      fluidRow(
        column(
          width = 12,
          tags$b("Result"),
          column(
            width = 12,
            verbatimTextOutput("results_1"),
          )
        )
      )
    )
  )


    server <- function(input, output, session) {
      # Define reactive expressions, outputs, etc.
      output$results_1 <-
      renderPrint(
        process(str = input$rank_list_1, prefix = prefix, post_fix = postfix, old_prefix = old_prefix)
      )


      # When the Done button is clicked, return a value
      observeEvent(input$done, {
        returnValue <- input$rank_list_1
        stopApp(returnValue)
      })
    }

    old_names <- runGadget(ui, server)
    new_names <-  process(str = old_names, prefix = prefix, post_fix = postfix, old_prefix = old_prefix)
    old_paths <- file.path(path, old_names)
    new_paths <- file.path(path, new_names)

    if(test_only){
      data.frame(old_paths, new_paths)
    } else {
      fs::file_move(old_paths, new_paths)
    }
}
