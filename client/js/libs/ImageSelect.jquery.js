// Image Select, an extention to the Chosen, a Select Box Enhancer for jQuery and Prototype
// by Adnan Sagar, WebSemantics Inc. http://websemantics.ca & AlterSpark Corp. http://www.alterspark.com/
//
// Version 1.0.2
// Full source at https://github.com/harvesthq/chosen
// Copyright (c) 2014 WebSemantics http://websemantics.ca

// MIT License, https://github.com/websemantics/Image-Select/blob/master/LICENSE

(function($) {

    // Image template, this can be overridden from the constructor (options.template), 
    // must contains {src} placeholder. Ther eare two class names 'chose-image' or 'chose-image-small', modifiy in CSS
    var fn_template = '<img class="{class_name}" src="{url}" />';
	var fn_icon_template = '<i class="{class_name}"> </i>';

    // Store the original 'chosen' method
    var fn_chosen = $.fn.chosen;

      $.fn.extend({
        // summery:
        //  Extend the original 'chosen' method to support images

        chosen: function(options) {
            
            options = options || {};
          
            var html_template = options.html_template || fn_template;

            // Attach Ready event before continue with chose
            this.each(function(input_field) {

                $this = $(this);
                
                $this.on("chosen:ready", function change(e, chosen){
                
                    chosen = chosen.chosen;

                    var form_field = chosen.form_field;

                    var options = form_field.options;
                    var spans = $(chosen.container).find('.chosen-choices span');

                      if(options && options.length){

                        for(var i = 0 ; i < options.length; i++){

                            var option = options[i];                
                            var selected = $(option).attr('selected');
                            var img_src = $(option).attr('data-img-src');
							var icon_class = $(option).attr('data-icon-class');
                            var text = $(option).text();

                            if(selected && img_src){

                              var template = html_template.replace('{url}',img_src);

                              if(spans.length){
                                for (var j = 0; j < spans.length; j++)
                                  if(text == $(spans[j]).text()){
                                    $(spans[j]).prepend(template.replace('{class_name}','chose-image'));
                                  }
                                } else {
                                  $(chosen.container).find('.chosen-single span').prepend(template.replace('{class_name}','chose-image-small'));
                                }
                            }else if(selected && icon_class){

                              var template = fn_icon_template.replace('{class_name}',icon_class);

                              if(spans.length){
                                for (var j = 0; j < spans.length; j++)
                                  if(text == $(spans[j]).text()){
                                    $(spans[j]).prepend(template);
                                  }
                                } else {
                                  $(chosen.container).find('.chosen-single span').prepend(template);
                                }
                            }

                        }
                    }

               });
            });

            // original behavior - use function.apply to preserve context
            var ret = fn_chosen.apply(this, arguments);

            this.each(function(input_field) {

                var $this, chosen;

                $this = $(this);

                chosen = $this.data('chosen');

                $this.on("change", function change(evt,selected){
                    // summery
                    //      This function is triggered when the chosen instance has changed, 
                    // evt: Event
                    //      The event object
                    // selected: Object
                    //      Contains the value of the selected
                    //  

                    var options = chosen.form_field.options;

                    if(selected != undefined && selected.selected != undefined && options && options.length){

                        for(var i = 0 ; i < options.length; i++){
                            var option = options[i];
                            var value =  ($(option).attr('value')) ? $(option).attr('value'):$(option).text();
                            var img_src = $(option).attr('data-img-src');
							var icon_class = $(option).attr('data-icon-class');

                            if(img_src != undefined && selected.selected == value){
                                var template = html_template.replace('{url}',img_src);

                                // For multiple selection
                                $(chosen.container).find('.chosen-choices span').last().prepend(template.replace('{class_name}','chose-image'));
                                
                                // For single select
                                $(chosen.container).find('.chosen-single span').prepend(template.replace('{class_name}','chose-image-small'));
                            }else if(icon_class != undefined && selected.selected == value){
                                var template = fn_icon_template.replace('{class_name}',icon_class);

                                // For multiple selection
                                $(chosen.container).find('.chosen-choices span').last().prepend(template);
                                
                                // For single select
                                $(chosen.container).find('.chosen-single span').prepend(template);
                            }
                        }
                    }
                });

                $this.on("chosen:showing_dropdown", function showing_dropdown(evt, _chosen){
                    // summery
                    //      This function is triggered when the chosen instance dropdown list becomes visible 
                    //  For Chose custom events: http://forwebonly.com/jquery-chosen-custom-events-and-how-to-use-them/
                    //
                    // evt: Event
                    //      The event object
                    // _chosen: Object {chosen:Chosen}
                    //      Contains the current instance of Chosen class

                    var lis = $(chosen.container).find('.chosen-drop ul li');
                    var options = chosen.form_field.options;

                    for(var i = 0 ; i < lis.length; i++){
                        var li = lis[i];
                        var option = options[i];
                        var img_src = $(option).attr('data-img-src');
						var icon_class = $(option).attr('data-icon-class');

                        if(img_src != undefined){
                            var template = html_template.replace('{url}',img_src);
                            $(li).prepend(template.replace('{class_name}','chose-image-list'));
                        }else if(icon_class != undefined){
                            var template = fn_icon_template.replace('{class_name}',icon_class);
                            $(li).prepend(template);
                        }
                    }
                  
                });

                // $this.trigger('change');

              });

            return ret;
        }
      });

})(jQuery);
