$( document ).ready(function() {

  var $allMovies = $('.all-movies'),
      $movie = $allMovies.children('div');

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
    });
  }

});