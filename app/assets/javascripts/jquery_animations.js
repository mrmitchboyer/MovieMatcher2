$( document ).ready(function() {
  
  var $question = $('.question'),
      $form = $('form'),
      $newQuestionBtn = $('.new-question');

  $question.hide();
  $question.first().show();

  $form.on("click", ".new-question", function() {
    $(this).parent().parent().next().slideDown("slow");
  });
  
});