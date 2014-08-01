$( document ).ready(function() {

  var $allMovies = $('.all-movies'),
      $movie = $allMovies.children('div'),
      $question = $('.question'),
      $multipleAlert = $('.multiple-alert'),
      $form = $('form'),
      $newQuestionBtn = $('.new-question');
      
  randomQuestions();
  newQuestion();
  sortMovies();
  showTopFive();
  changeColor();

  function sortMovies(){

    $movie.sort(function(a,b){
      var aData = a.getAttribute('data-name'),
          bData = b.getAttribute('data-name');

      if(aData < bData) {
        return 1;
      }
      if(aData > bData) {
        return -1;
      }
      return 0;
    });

    $movie.detach().appendTo($allMovies);
  }

  function hideAlert() {
    $multipleAlert.show().delay(3000).fadeOut();
  }

  function showTopFive(){
    $movie.hide();
    $movie.slice(0,5).show();

    $('.show-all-movies').click(function(){
      $movie.show();
      $(this).hide();
  });
  };

  function changeColor() {
    $('.score').each(function(node) {
        var sliced_node = $(this).text().slice(0, -1);
        var new_node = parseInt(sliced_node);
          if(new_node >= 70) {
            $(this).parent().css("background-color", "green");
          }
          else if(new_node < 70 && new_node > 30) {
            $(this).parent().css("background-color", "yellow");
          }
          else if(new_node <= 30) {
            $(this).parent().css("background-color", "red");
          }
    }
    );
  }

  function randomQuestions(){
    $question.sort(function(){return Math.random()*10 > 5 ? 1 : -1;}).each(function(){
        $question.detach().prependTo($form);
    });

  }

  function newQuestion(){
    $question.hide();
    $question.first().show(function(){  
      hideAlert(); 
    }); 
    
    $form.on("click", ".new-question", function() {
      $(this).parent().parent().hide();
      $(this).parent().parent().next().fadeIn("slow", function(){
        hideAlert();
      });
    });
    }
});
