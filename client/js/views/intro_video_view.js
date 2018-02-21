/**
 * intro_video View
 * @class introvideoview
 * @constructor
 * @extends Backbone.View
 */

App.intro_video_view = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        var field = $('#content').attr('class');
        if (field === "container-fluid") {
            this.render();
        }
    },
    events: {
        'click .js-intro-video-skip': 'skipVideo'
    },
    template: JST['templates/intro_video'],
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        $('#content').addClass('intro_video');
        if (authuser.user.is_intro_video_skipped === "f" || authuser.user.is_intro_video_skipped === null) {
            this.$el.dockmodal({
                height: 300,
                width: 200,
                animationSpeed: ANIMATION_SPEED,
                title: '<div class="col-xs-12"><div class="text-center"><strong>Introduction Video</strong></div></div>',
                beforePopout: function(event) {
                    if ($(window).width() < 1400) {
                        $('.editor').resizable({
                            maxWidth: 1000,
                            minWidth: 500
                        });
                    } else {
                        $('.editor').resizable({
                            maxWidth: 1050,
                            minWidth: 500
                        });
                    }
                    $('.editor').each(function() {
                        var $this = $(this);
                        var factor1 = $.cookie('factor1');
                        if ((factor1 === null) || (typeof factor1 === 'undefined')) {
                            factor1 = '30';
                            factor2 = '70';
                        } else {
                            factor2 = 100 - factor1;
                        }
                        $this.resizable({
                            handles: 'e',
                            resize: function(event, ui) {
                                var x = ui.element.outerWidth();
                                var ele = ui.element;
                                var factor = x * 100 / $(this).parent().width();
                                var f1 = factor;
                                var f2 = 100 - factor;
                                $.cookie('factor1', f1);
                                $this.css('width', f1 + '%');
                                $this.next().css('width', f2 + '%');
                            }
                        }).css({
                            width: factor1 + '%'
                        }).next().css({
                            width: factor2 + '%'
                        });
                    });
                },
                beforeRestore: function(event) {
                    $('.editor').resizable({
                        maxWidth: 380,
                        minWidth: 350
                    });
                    $('.editor').each(function() {
                        var $this = $(this);
                        var factor1 = '60';
                        var factor2 = '40';
                        $this.resizable({
                            handles: 'e',
                            resize: function(event, ui) {
                                var x = ui.element.outerWidth();
                                var ele = ui.element;
                                var factor = x * 100 / $(this).parent().width();
                                var f1 = factor;
                                var f2 = 100 - factor;
                                $this.css('width', f1 + '%');
                                $this.next().css('width', f2 + '%');
                            }
                        }).css({
                            width: factor1 + '%'
                        }).next().css({
                            width: factor2 + '%'
                        });
                    });
                },
                open: function(event, dialog) {
                    $('.dockmodal').removeClass('active');
                    event.parent().parent().addClass('active');
                    $('.dockmodal').click(function(e) {
                        $('.dockmodal').removeClass('active');
                        $(this).addClass('active');
                    });
                    $(window).bind('keydown', function(e) {
                        if (e.keyCode === 27) {
                            $('.action-close', $('.dockmodal.active')).trigger('click');
                        }
                    });
                }
            });
            this.$el.html(this.template);
        }
        return this;
    },
    /**
     * skipVideo()
     * To skip the intro video for users
     * @param NULL
     * @return object
     *
     */
    skipVideo: function(e) {
        var data = {};

        data.is_intro_video_skipped = 1;

        $('.action-close', ('.dockmodal-header')).trigger('click');
        var introvideo = new App.intro_view_model();
        introvideo.url = api_url + 'users/' + authuser.user.id + '.json';
        introvideo.save(data, {
            success: function(response) {
                if (!_.isEmpty(response.attributes.success)) {
                    var Auth = JSON.parse($.cookie('auth'));
                    Auth.user.is_intro_video_skipped = response.attributes.is_intro_video_skipped;
                    $.cookie('auth', JSON.stringify(Auth));
                    authuser = Auth;
                }
            }
        });
    }
});
