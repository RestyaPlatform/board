/**
 * popup View
 * @class popupView
 * @constructor
 * @extends Backbone.View
 */

App.popupView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (window.location.hash === "#/boards") {
            this.render();
        }
    },
    template: JST['templates/popup'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        if (authuser.user.is_show_community_edition_popup === "t") {
            this.$el.dockmodal({
                height: 500,
                width: 200,
                animationSpeed: ANIMATION_SPEED,
                title: "<div class='col-xs-12'><div class='text-center'><strong>" + i18next.t('Upgrade to Enterprise Edition') + "</strong></div></div>",
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
                        var factor1 = '30',
                            factor2 = '70';
                        if (!_.isUndefined(authuser.user) && !_.isEmpty(authuser.user)) {
                            if (!_.isUndefined(authuser.user.persist_card_divider_position) && authuser.user.persist_card_divider_position !== null) {
                                factor1 = authuser.user.persist_card_divider_position;
                                factor2 = 100 - factor1;
                            }
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
                            },
                            stop: function(event, ui) {
                                var x = ui.element.outerWidth();
                                var factor = x * 100 / $(this).parent().width();
                                if (!_.isUndefined(authuser.user) && !_.isEmpty(authuser.user)) {
                                    var data = {
                                        persist_card_divider_position: factor
                                    };
                                    var user = new App.User();
                                    user.url = api_url + 'users/' + authuser.user.id + '.json';
                                    user.set('id', parseInt(authuser.user.id));
                                    user.save(data, {
                                        success: function(model, response) {
                                            var Auth = JSON.parse($.cookie('auth'));
                                            Auth.user.persist_card_divider_position = factor;
                                            $.cookie('auth', JSON.stringify(Auth));
                                            authuser = Auth;
                                        }
                                    });
                                }
                            },
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
                    $('.dockmodal').css('height', '500');
                },
                close: function(event, dialog) {
                    var data = {};
                    data.is_show_community_edition_popup = 0;
                    var user = new App.User();
                    user.url = api_url + 'users/' + authuser.user.id + '.json';
                    user.save(data, {
                        success: function(response) {
                            if (!_.isEmpty(response.attributes.success)) {
                                var Auth = JSON.parse($.cookie('auth'));
                                Auth.user.is_show_community_edition_popup = 0;
                                $.cookie('auth', JSON.stringify(Auth));
                                authuser = Auth;
                            }
                        }
                    });
                }
            });
            this.$el.html(this.template);
        }
        return this;
    },
    closePopup: function(e) {
        e.preventDefault();
        $('.action-close', $('.dockmodal.active')).trigger('click');
    }
});
