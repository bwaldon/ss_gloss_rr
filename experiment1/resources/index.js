var order = 1;

var stims = [{prime_expr: "about 30", target_expr: "about 30", neg: true, neg_print: "haven't"}, {prime_expr: "between 25 and 30", target_expr: "between 25 and 30", neg: false, neg_print: "have"}]

function make_slides(f) {
  var slides = {};
  var present_list = stims; //

  slides.consent = slide({
     name : "consent",
     start: function() {
      exp.startT = Date.now();
      $("#consent_2").hide();
      exp.consent_position = 0;
     },
    button : function() {
      if(exp.consent_position == 0) {
         exp.consent_position++;
         $("#consent_1").hide();
         $("#consent_2").show();
      } else {
        exp.go(); //use exp.go() if and only if there is no "present" data.
      }
    }
  });

 slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
     }
  });

 slides.trial = slide({
     name : "trial",
     present : present_list,
     start: function() {
      exp.startT = Date.now();
       
     },

     present_handle : function(stim) {
     	this.stim = stim;
     	$(".prompt").html("<i>Speaker A:</i> This  afternoon, " + stim.prime_expr + " delegates  will  be  coming  to  the  planning  meeting.    Have  we  printed  copies  of  the  agenda  for  them?  <p> <i>Speaker B:</i> <b> We " + stim.neg_print + " printed " + stim.target_expr + " copies  of  the  agenda.</b>");
     },

     button: function() {
      if ($('input[name="rating"]:checked').val() == undefined) {
      	$(".error").show();
      } else {
      	this.log_responses();

        /* use _stream.apply(this); if and only if there is
        "present" data. (and only *after* responses are logged) */
        _stream.apply(this);
        $('input[name="rating"]').attr('checked',false);
      }
  },
      log_responses: function() {
      exp.data_trials.push({
        "rating" : $('input[name="rating"]:checked').val(),
        "vignette" : this.stim.vignette,
        "sentence" : this.stim.sentence,
        "condition" : this.stim.condition,
        "order" : order,
      });
    order = order + 1;
     }
  });

  slides.instructions = slide({
    name : "instructions",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
      //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = {
        language : $("#language").val(),
        enjoyment : $("#enjoyment").val(),
        asses : $('input[name="assess"]:checked').val(),
        age : $("#age").val(),
        gender : $("#gender").val(),
        education : $("#education").val(),
        comments : $("#comments").val(),
        problems: $("#problems").val(),
        fairprice: $("#fairprice").val()
      };
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
          "trials" : exp.data_trials,
          "catch_trials" : exp.catch_trials,
          "system" : exp.system,
          "subject_information" : exp.subj_data,
          "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      setTimeout(function() {turk.submit(exp.data);}, 1000);
    }
  });

  return slides;
}

/// init ///
function init() {
  exp.trials = [];
  exp.catch_trials = [];
  //exp.condition = _.sample([1-4]); //can randomize between subject conditions here
  // exp.order = _.sample(["4fillerspacing","nofillerspacing"]);
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
  //blocks of the experiment:
  exp.structure=["consent","i0","instructions","trial","thanks"];

  exp.data_trials = [];
  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    } else {
      $("#start_button").click(function() {$("#mustaccept").show();});
      exp.go();
    }
  });

  exp.go(); //show first slide
}
