$( document ).ready(function() {
  
  var $question = $('.question'),
      $newQuestionBtn = $('.new-question');

  $question.hide();
  $question.first().show();

  $newQuestionBtn.click(function() {
    $question.next().slideDown("slow");
  });

  
});