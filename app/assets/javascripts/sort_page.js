$( document ).ready(function() {

  var $allMovies = $('.all-movies'),
      $movie = $allMovies.children('div'),
      $question = $('.question'),
      $form = $('form'),
      $newQuestionBtn = $('.new-question');
      $note = $('.note')
      

  randomQuestions();
  newQuestion();
  sortMovies();
  showTopFive();


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

  function showTopFive(){
    $movie.hide();
    $movie.slice(0,5).show();

    $('.show-all-movies').click(function(){
      $movie.show();
      $(this).hide();
    });
  }

  function randomQuestions(){
    $question.sort(function(){return Math.random()*10 > 5 ? 1 : -1;}).each(function(){
        $question.detach().prependTo($form);
    });

  }

  function newQuestion(){
    $question.hide();
    $question.first().show(); 
    
    $form.on("click", ".new-question", function() {
      $(this).parent().parent().hide();
      $(this).parent().parent().next().fadeIn("slow");
    });
  }

});