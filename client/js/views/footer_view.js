/**
 * @fileOverview This file has functions related to list view. This view calling from application view and board view.
 * boardActivities() used for sync @see boardActivities function below
 * Available Object:
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Footer View
 * @class FooterView
 * @constructor
 * @extends Backbone.View
 */
App.FooterView = Backbone.View.extend({
    converter: new showdown.Converter({
        extensions: window.extensionslist
    }),
    template: JST['templates/footer'],
    className: 'action-sheet',
    id: 'footer-menu',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-open-popover': 'openPopup',
        'click .js-show-organizations-board-from': 'showOrganizationsBoardFrom',
        'click .js-show-board-import-forms': 'showBoardImports',
        'click .js-show-board-add-form': 'showBoardAddForm',
        'click .js-show-organizations-add-form': 'showOrganizationsAddForm',
        'click .js-show-qr-code': 'showQrCode',
        'click .js-appModal-close': 'appModalClose',
        'click .js-appModal-open': 'appModalOpen',
        'click .js-show-boards-list': 'showBoardsList',
        'click .js-collapse-myboards': 'collapseMyBoards',
        'click .js-collapse-closedboards': 'collapseClosedBoards',
        'click .js-collapse-starred-boards': 'collapseStarredBoards',
        'click .js-expand-myboards': 'expandMyBoards',
        'click .js-expand-closedboards': 'expandClosedBoards',
        'click .js-expand-starred-boards': 'expandStarredBoards',
        'keyup .js-search-boards': 'showSearchBoards',
        'click .js-all-activities': function() {
            $('#js-load-link2, .js-all-activity-list').removeClass('hide');
            $('#js-load-link1, .js-boards-activity-list').addClass('hide');
            $('#js-all-activities').empty();
            this.userActivities(false, 2);
        },
        'click .js-all-user-activities': 'showUserActivities',
        'click .js-product-beat-action': 'actionBeat',
        'click .js-board-activities': function() {
            $('#js-notification-load-more').removeClass('js-all-load-more').addClass('js-board-load-more');
            $('#js-notification-load-more-all').removeClass('js-all-load-more-all').addClass('js-board-load-more-all');
            $('#js-load-link2, .js-all-activity-list').addClass('hide');
            $('#js-load-link1, .js-boards-activity-list').removeClass('hide');
            $('#js-board-activities').empty();
            this.boardActivities();
        },
        'click .js-all-board-activities': 'showBoardActivities',
        'click .js-notification-menu': 'notificationMenu',
        'click .js-show-notification': 'showNotification',
        'click .js-change-language': 'changeLanguage',
        'click .js-back-boards-list': 'showBackBoardsList',
        'click .js-back-add-boards-list': 'showBackAddBoardList',
        'click .js-board-load-more': function(e) {
            e.preventDefault();
            this.loadMore('board', '1');
            return false;
        },
        'click .js-all-load-more': function(e) {
            e.preventDefault();
            this.loadMore('user', '1');
            return false;
        },
        'click .js-board-load-more-all': function(e) {
            e.preventDefault();
            this.loadMore('user', '0');
            return false;
        },
        'click .js-all-load-more-all': function(e) {
            e.preventDefault();
            this.loadMore('user', '0');
            return false;
        },
        'click .js-enable-desktop-notification': 'enabledesktopNotification',
        'click .js-show-board-import-form': 'showBoardImportForm',
        'change .js-board-import-file': 'importBoard',
        'click .js-show-board-import-wekan-form': 'showBoardImportWekanForm',
        'click .js-show-board-import-kantree-form': 'showBoardImportKantreeForm',
        'click .js-show-board-import-monday-form': 'showBoardImportMondayForm',
        'click .js-show-board-import-taiga-form': 'showBoardImportTaigaForm',
        'click .js-show-board-import-pipefy-form': 'showBoardImportpipefyForm',
        'click .js-show-board-import-asana-form': 'showBoardImportAsanaForm',
        'click .js-show-board-import-taskwarrior-form': 'showBoardImportTaskwarriorForm',
        'change .js-board-import-wekan-file': 'importWekanBoard',
        'change .js-board-import-kantree-file': 'importKantreeBoard',
        'change .js-board-import-monday-file': 'importMondayBoard',
        'change .js-board-import-taiga-file': 'importTaigaBoard',
        'change .js-board-import-pipefy-file': 'importpipefyBoard',
        'change .js-board-import-asana-file': 'importAsanaBoard',
        'change .js-board-import-taskwarrior-file': 'importTaskwarriorBoard',
        'click .js-closed-boards': 'renderClosedBoards',
        'click .js-starred-boards': 'renderStarredBoards',
        'click .js-my-boards-listing': 'renderMyBoards',
        'click #modal-activities': 'showActivity',
        'click #modal-comments': 'showActivity',
        'click .js-show-shortcuts-modal': 'showShortcutModal',
        'keyup[shift+/] body': 'keyboardShowShortcutModal',
        'click .js-footer-board-link': 'gotoBoards',
    },
    /** 
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.music_content = '';
        if (!_.isUndefined(App.music) && App.music.music_content !== null) {
            this.music_content = App.music.music_content;
        }
        this.music_name = '';
        if (!_.isUndefined(App.music) && App.music.music_name !== null) {
            this.music_name = App.music.music_name;
        }
        this.board_id = options.board_id;
        this.board = options.board;
        this.boards = options.boards;
        _.bindAll(this, 'renderClosedBoards', 'renderStarredBoards');
    },
    /**
     * gotoBoards()
     * To go to board
     * @param e
     * @type Object(DOM event)
     *
     */
    gotoBoards: function(e) {
        e.preventDefault();
        var self = this;
        var currenturl = window.location;
        var currentss = currenturl.hash;
        var get_match_url = currentss.split("/");
        if ($('#boards-index').length === 0 || (!_.isUndefined(get_match_url) && !_.isEmpty(get_match_url) && get_match_url.length > 0 && get_match_url['1'] === 'search')) {
            app.navigate('#/boards', {
                trigger: true,
                replace: true
            });
            $('#search-page-result-block').html('');
        }
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.converter.setFlavor('github');
        var self = this;
        this.model.is_show_enable_notification = false;
        var current_param = Backbone.history.fragment;
        var current_param_split = current_param.split('/');
        this.showTooltip();
        this.model.current_param = (current_param.indexOf('changepassword') === -1 && current_param.indexOf('login') === -1 && current_param.indexOf('forgotpassword') === -1 && current_param.indexOf('register') === -1 && current_param.indexOf('activation') === -1) ? current_param_split[0] : '';
        if (typeof Notification != 'undefined') {
            this.model.is_show_enable_notification = (Notification.permission == 'default') ? true : false;
        }
        if (typeof Notification != 'undefined' && Notification.permission !== 'granted') {
            Notification.requestPermission(function(permission) {
                if (!('permission' in Notification)) {
                    Notification.permission = permission;
                }
                if (permission === 'granted') {
                    var notification = new Notification('Desktop notification enabled.');
                    location.reload();
                }
            });
        }
        var in_boards_page = false;
        var url = window.location.hash.split('/');
        if (url.length === 2 && url['1'] === 'boards') {
            in_boards_page = true;
        }
        var current_language;
        if ($.cookie('auth') !== undefined && $.cookie('auth') !== null && authuser.user.language !== null && !_.isUndefined(authuser.user.language) && !_.isEmpty(authuser.user.language)) {
            current_language = authuser.user.language;
        } else if (navigator.language || navigator.userLanguage) {
            var languages = ($.cookie('languages')) ? $.cookie('languages').split(',') : null;
            if (languages !== null) {
                languages = JSON.parse(languages);
            }
            current_language = navigator.language || navigator.userLanguage;
            var language_reg = current_language.split('-');
            if (language_reg.length > 1) {
                language_reg['1'] = language_reg['1'].toUpperCase();
            }
            current_language = language_reg.join('_');
            current_language = current_language.replace("-", "_");
            if (!_.isUndefined(languages) && !_.isEmpty(languages) && languages !== null) {
                if (_.isUndefined(languages[current_language]) || languages[current_language] === null || _.isEmpty(languages[current_language])) {
                    current_language = DEFAULT_LANGUAGE;
                }
            }
        } else {
            current_language = DEFAULT_LANGUAGE;
        }
        self.$el.html(self.template({
            model: self.model,
            board_id: self.board_id,
            board: self.board,
            languages: ($.cookie('languages')) ? $.cookie('languages').split(',') : null,
            'current_language': current_language,
            apps: overallApps,
            'in_boards_page': in_boards_page,
            converter: self.converter,
        }));
        if (_.isEmpty(this.board_id)) {
            if (!_.isUndefined(authuser.user)) {
                var board_activities = new App.FooterView({
                    model: authuser,
                    boards: self.boards
                });
                if (authuser.user.notify_count > 0) {
                    $('.js-notification-count').removeClass('hide').html(authuser.user.notify_count);
                    favicon.badge(authuser.user.notify_count);
                } else {
                    favicon.badge(0);
                    $('.js-notification-count').addClass('hide');
                }
                clearInterval(set_interval_id);
                set_interval_id = setInterval(function() {
                    board_activities.userActivities(false, 1);
                }, 10000);
            }
            $('#js-load-link1').addClass('hide');
            $('#js-load-link2').addClass('hide');
        } else {
            $('#js-load-link2').addClass('hide');
        }
        return this;
    },
    cardsort: function(sort_by, sort_direction, list_cards) {
        var filtered_cards = list_cards.filter(function(card) {
            return parseInt(card.attributes.is_archived) === 0;
        });
        if (!_.isEmpty(filtered_cards)) {
            var cards = new App.CardCollection();
            cards.reset(filtered_cards, {
                silent: true
            });
            if (sort_by !== null && sort_direction !== null) {
                cards.sortByColumn(sort_by, sort_direction);
            } else {
                cards.sortByColumn('position');
            }
            return cards;
        }
    },
    FilterCards: function(current_param, card) {
        if (($('div#board_view_header').find('li.selected > div.js-label', $('ul.js-board-labels')).length !== 0 || $('div#board_view_header').find('li.selected > div.media > span.navbar-btn > span.js-user', $('ul.js-board-users')).length !== 0 || $('div#board_view_header').find('li.selected', $('ul.js-board-colors')).length !== 0 || $('div#board_view_header').find('li.selected > div.media > span.js-due', $('ul.js-board-dues')).length !== 0)) {
            var currenturl = window.location;
            var currentss = currenturl.hash;
            var get_match_url = currentss.split("/");
            if ((!_.isUndefined(get_match_url['3']) && get_match_url['3'].indexOf("list") !== -1) || (!_.isUndefined(get_match_url['1']) && get_match_url['1'] === 'board' && $('#switch-board-view').find('#js-board-lists').length !== 0)) {
                var dictFilter = filter_getFilterObject(current_param, []);
                var arrays = dictFilter.arrays;
                var filter_query = dictFilter.filter_query;
                if (!_.isEmpty(arrays) && !_.isEmpty(filter_query)) {
                    var result = arrays.shift().filter(function(v) {
                        return arrays.every(function(a) {
                            return a.indexOf(v) !== -1;
                        });
                    });
                    var unfilteredIds = [];
                    for (var i = 0; i < result.length; i++) {
                        if (!_.isUndefined(result[i])) {
                            var card_id = result[i].substring(8, result[i].length);
                            if ($.inArray(card_id, unfilteredIds) === -1) {
                                unfilteredIds.push(parseInt(card_id));
                            }
                        }
                    }
                    var filter = card.get('is_archived') !== 1 && unfilteredIds.indexOf(card.get('id')) === -1;
                    card.set('is_filtered', filter, {
                        silent: true
                    });
                    if ($('#js-card-' + card.id).length !== 0) {
                        if (filter) {
                            $('#js-card-' + card.id).addClass('hide');
                        } else {
                            if (!_.isUndefined(get_match_url['3']) && get_match_url['3'].indexOf("list") !== -1) {
                                $('#js-card-' + card.id).removeClass('hide');
                            } else {
                                $('#js-card-' + card.id).removeClass('hide');
                            }
                        }
                    }
                }
            }
        }
    },
    /**
     * actionBeat()
     * show instant card add form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    actionBeat: function(e) {
        var type = $(e.currentTarget).data('type');
        var set_type = '';
        var set_icon = '';
        var set_animation = '';
        var remove_animation = '';
        var remove_icon = '';
        var volume = false;
        if (type === 'off') {
            volume = true;
            set_type = 'on';
            set_icon = 'icon-volume-up';
            set_animation = 'audio-animation';
            remove_icon = 'icon-volume-off text-muted';
        } else {
            set_type = 'off';
            set_icon = 'icon-volume-off text-muted';
            remove_icon = 'icon-volume-up';
            remove_animation = 'audio-animation';
        }
        var music_content = '';
        if (!_.isUndefined(authuser.user) && !_.isUndefined(authuser.user.is_productivity_beats)) {
            var user = new App.User();
            user.url = api_url + 'users/' + authuser.user.id + '.json';
            user.set('id', parseInt(authuser.user.id));
            user.save({
                'is_productivity_beats': volume
            });
            if (volume === true) {
                authuser.user.is_productivity_beats = 1;
            } else {
                authuser.user.is_productivity_beats = 0;
            }
            var Auth = JSON.parse($.cookie('auth'));
            if (volume === true) {
                volume = 1;
            } else {
                volume = 0;
            }
            Auth.user.is_productivity_beats = volume;
            $.cookie('auth', JSON.stringify(Auth));
        } else {
            if (volume === true) {
                $.cookie('music_play', "1");
            } else {
                $.cookie('music_play', "0");
            }
        }
        $(e.currentTarget).data('type', set_type);
        $(e.currentTarget).find('i').removeClass(remove_icon).addClass(set_icon);
        $(e.currentTarget).find('i').removeClass(remove_animation).addClass(set_animation);
        if (!_.isEmpty(App.music.music_content) && App.music.music_content != 'NULL') {
            var repeatMusic = new App.MusicRepeatView();
            repeatMusic.continueMusic();
        }
        return false;
    },
    /**
     * changeLanguage()
     * Change language
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    changeLanguage: function(e) {
        e.preventDefault();
        var self = this;
        authuser.user.language = $(e.currentTarget).data('lang');
        var Auth = JSON.parse($.cookie('auth'));
        Auth.user.language = $(e.currentTarget).data('lang');
        $.cookie('auth', JSON.stringify(Auth));
        var user = new App.User();
        user.url = api_url + 'users/' + authuser.user.id + '.json';
        user.set('id', parseInt(authuser.user.id));
        user.save({
            'language': $(e.currentTarget).data('lang')
        }, {
            success: function(user, response) {
                i18next.changeLanguage($(e.currentTarget).data('lang'));
                if (!_.isEmpty(response.success)) {
                    $('.js-change-language-form-response').find('i').remove();
                }
                location.reload();
            }
        });
        return false;
    },
    /**
     * showQrCode()
     * show QR code form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showQrCode: function(e) {
        e.preventDefault();
        var qr_code = new App.QrCodeView({
            model: qr_code,
        });
        return false;
    },
    /**
     * appModalOpen()
     * trigger the app function while modal popup for the apps opens
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    appModalOpen: function(e) {
        e.preventDefault();
        var self = this;
        _(function() {
            if ($('.js-appModalContent').find('.modal-backdrop').length === 0) {
                $('.modal-backdrop').appendTo('.js-appModalContent');
            }
            if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                $('body').trigger('appPopupAction', e);
            }
        }).defer();
        return this;
    },
    /**
     * appModalClose()
     * close the modal popup for the apps
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    appModalClose: function(e) {
        e.preventDefault();
        $(e.target).parents('.modal').modal('hide');
        return false;
    },
    /**
     * showBackBoardsList()
     * Back to Boards list form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showBackBoardsList: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').addClass('open');
        this.$el.find('li.js-back').remove();
        this.showBoardsList(e);
        return false;
    },
    /**
     * showBackAddBoardList()
     * Back to Add Boards list form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showBackAddBoardList: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').addClass('open');
        this.$el.find('li.js-import-boards-back').remove();
        this.$el.find('.js-board-import-info').remove();
        this.$el.find('.js-back').removeClass('hide');
        return false;
    },
    /**
     * openPopup()
     * show dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    openPopup: function(e) {
        var target = $(e.target).parents('.dropdown:first');
        target.addClass('open').siblings('.dropdown.open').removeClass('open');
        var headerH = $('header').height();
        var footerH = $('footer').height();
        var windowH = $(window).height();
        var boardH = windowH - headerH - footerH - 14;
        var boardlistH = $(e.target).next('.sidebar-boards-list').height();
        if (boardlistH > boardH) {
            $(e.target).next('.sidebar-boards-list').css({
                'max-height': boardH - 35
            });
            $(e.target).next('.sidebar-boards-list').addClass('vertical-scrollbar');
        }
        return false;
    },
    /**
     * showOrganizationsBoardFrom()
     * show organizations and board add link
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showOrganizationsBoardFrom: function(e) {
        e.preventDefault();
        $('.js-show-boards-list-response').removeClass('hide');
        $('.js-boards-list-container-search').addClass('hide');
        $('.js-boards-list-container').addClass('hide');
        $('.js-qsearch-container').addClass('hide');
        $('li.js-board-search-result').remove();
        $('#inputBoardSearch').val('');
        var target = $(e.target);
        var parent = target.parents('.js-show-add-boards-list');
        var insert = $('.js-show-boards-list-response', parent);
        $(new App.OrganizationsBoardFormView({}).el).insertAfter(insert);
        $('.js-show-boards-list-response').html('');
        return false;
    },
    /**
     * showBoardImportForm()
     * show board import options
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showBoardImports: function(e) {
        e.preventDefault();
        var target = $(e.target);
        this.$el.find('.js-back').addClass('hide');
        var parent = target.parents('.js-show-add-boards-list');
        var insert = $('.js-show-boards-list-response', parent);
        $(new App.BoardImportFormView({}).el).insertAfter(insert);
        $('footer').trigger('footerActionRendered');
        $('.js-show-boards-list-response').html('');
        this.showTooltip();
        return false;
    },
    /**
     * showBoardAddForm()
     * show board add form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showBoardAddForm: function(e) {
        var self = this;
        var data = {};
        var load_workflow_template = false;
        load_workflow_template = (parseInt(authuser.user.role_id) === 1 || !_.isEmpty(role_links.where({
            slug: "view_workflow_templates"
        })));
        if (load_workflow_template) {
            var workflow_template = new App.WorkFlowTemplateCollection();
            workflow_template.url = api_url + 'workflow_templates.json';
            workflow_template.fetch({
                success: function(model, response) {
                    var templates = '';
                    self.$el.find('li.js-back').remove();
                    var target = $(e.target);
                    var parent = target.parents('.js-show-add-boards-list');
                    var insert = $('.js-show-boards-list-response', parent);
                    $('.js-show-boards-list-response').html(new App.BoardAddView({
                        model: workflow_template
                    }).el).find('#inputtemplatelist').select2({
                        formatResult: function(repo) {
                            markup = '<div class="clearfix"><span class="show">' + repo.text + '</span><span class="show small">' + repo.id + '</span></div>';
                            return markup;
                        }
                    });
                }
            });
        } else {
            self.$el.find('li.js-back').remove();
            $('.js-show-boards-list-response').html(new App.BoardAddView({
                model: data
            }).el);
        }
        $('footer').trigger('footerActionRendered');
        return false;
    },
    /**
     * showOrganizationsAddForm()
     * show board add form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showOrganizationsAddForm: function(e) {
        this.$el.find('li.js-back').remove();
        var target = $(e.target);
        var parent = target.parents('.js-show-add-boards-list');
        var insert = $('.js-show-boards-list-response', parent);
        $('.js-show-boards-list-response').html(new App.OrganizationAddView().el);
        $('footer').trigger('footerActionRendered');
        return false;
    },
    /**
     * showBoardsList()
     * display board lists
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardsList: function() {
        $('.js-boards-list-container-search').removeClass('hide');
        $('.js-boards-list-container').addClass('hide');
        $('.js-qsearch-container').removeClass('hide');
        $('.js-show-boards-list-response').addClass('hide');
        this.$el.find('li.js-back').remove();
        this.$el.find('.js-board-import-info').remove();
        this.$el.find('li.js-import-boards-back').remove();
        var recent_boards = '';
        var my_boards = '';
        var self = this;
        self.boards = App.boards;
    },
    /**
     * renderMyBoards()
     * collapse my board lists
     * @return false
     *
     */
    renderMyBoards: function() {
        if (!_.isUndefined(App.boards) && !_.isUndefined(App.boards.sortField) && App.boards.sortField !== null && App.boards.sortField !== 'name') {
            App.boards.setSortField('name', 'asc');
            App.boards.sort();
        }
        this.boards = App.boards;
        if (!_.isEmpty(this.boards) && !_.isEmpty(role_links.where({
                slug: 'view_my_boards'
            }))) {
            var view_my_board = $('.js-myboard-list');
            view_my_board.html('');
            var is_displayed = false;
            if (!_.isEmpty(App.boards.models)) {
                _.each(App.boards.models, function(board) {
                    if (parseInt(board.attributes.is_closed) === 0) {
                        is_displayed = true;
                        view_my_board.append(new App.MyBoardsListingView({
                            model: board,
                            authuser: authuser,
                            attributes: {
                                class: 'js-show-board-star'
                            }
                        }).el);
                    }
                });
            }
            if (!is_displayed) {
                view_my_board.html(new App.MyBoardsListingView({
                    model: null,
                    authuser: authuser,
                    attributes: {
                        class: 'clearfix text-center'
                    }
                }).el);
            }
        }
    },
    /**
     * renderStarredBoards()
     * collapse my board lists
     * @return false
     *
     */
    renderStarredBoards: function() {
        this.boards = App.boards;
        if (!_.isEmpty(this.boards) && !_.isEmpty(role_links.where({
                slug: 'view_stared_boards'
            }))) {
            var view_starred_board = $('.js-board-starred-list');
            view_starred_board.html('');
            var is_displayed = false;
            if (!_.isEmpty(App.boards.models)) {
                _.each(App.boards.models, function(board) {
                    var starred = board.boards_stars.findWhere({
                        board_id: parseInt(board.id),
                        user_id: parseInt(authuser.user.id),
                        is_starred: 1
                    });
                    if (!_.isUndefined(starred) && !_.isEmpty(starred) && (parseInt(board.attributes.is_closed) === 0)) {
                        is_displayed = true;
                        view_starred_board.append(new App.StartedBoardsListingView({
                            model: board,
                            authuser: authuser,
                            attributes: {
                                class: 'js-show-board-star'
                            }
                        }).el);
                    }
                });
            }
            if (!is_displayed) {
                view_starred_board.html(new App.StartedBoardsListingView({
                    model: null,
                    authuser: authuser,
                    attributes: {
                        class: 'clearfix text-center'
                    }
                }).el);
            }
        }
    },
    /**
     * renderClosedBoards()
     * collapse my board lists
     * @return false
     *
     */
    renderClosedBoards: function() {
        if (!_.isEmpty(role_links.where({
                slug: 'view_closed_boards'
            }))) {
            var view_closed_board = $('.js-closedboard-list');
            view_closed_board.html('');
            var is_displayed = false;
            if (!_.isEmpty(App.boards.models)) {
                _.each(App.boards.models, function(board) {
                    if (parseInt(board.attributes.is_closed) === 1) {
                        is_displayed = true;
                        view_closed_board.append(new App.ClosedBoardsListingView({
                            model: board,
                            attributes: {
                                class: 'js-show-board-closed panel-default well-sm clearfix'
                            }
                        }).el);
                    }
                });
            }
            if (!is_displayed) {
                view_closed_board.html(new App.ClosedBoardsListingView({
                    model: null,
                    attributes: {
                        class: 'clearfix text-center'
                    }
                }).el);
            }
        }
    },
    /**
     * collapseMyBoards()
     * collapse my board lists
     * @return false
     *
     */
    collapseMyBoards: function() {
        $('.js-myboard-list').addClass('hide');
        $('.js-collapse-myboards').addClass('hide');
        $('.js-expand-myboards').removeClass('hide');
        return false;
    },
    /**
     * expandMyBoards()
     * expand my board lists
     * @return false
     *
     */
    expandMyBoards: function() {
        $('.js-myboard-list').removeClass('hide');
        $('.js-collapse-myboards').removeClass('hide');
        $('.js-expand-myboards').addClass('hide');
        return false;
    },
    /**
     * collapseMyClosedBoards()
     * collapse my closed board lists
     * @return false
     *
     */
    collapseClosedBoards: function() {
        $('.js-closedboard-list').addClass('hide');
        $('.js-collapse-closedboards').addClass('hide');
        $('.js-expand-closedboards').removeClass('hide');
        return false;
    },
    /**
     * expandMyClosedBoards()
     * expand my closed board lists
     * @return false
     *
     */
    expandClosedBoards: function() {
        $('.js-closedboard-list').removeClass('hide');
        $('.js-collapse-closedboards').removeClass('hide');
        $('.js-expand-closedboards').addClass('hide');
        return false;
    },
    /**
     * collapseStarredBoards()
     * collapse starred board lists
     * @return false
     *
     */
    collapseStarredBoards: function() {
        $('.js-board-starred-list').addClass('hide');
        $('.js-collapse-starred-boards').addClass('hide');
        $('.js-expand-starred-boards').removeClass('hide');
        return false;
    },
    /**
     * expandStarredBoards()
     * expand starred board lists
     * @return false
     *
     */
    expandStarredBoards: function() {
        $('.js-board-starred-list').removeClass('hide');
        $('.js-collapse-starred-boards').removeClass('hide');
        $('.js-expand-starred-boards').addClass('hide');
        return false;
    },
    /**
     * showSearchBoards()
     * display board search form
     * @param e
     * @type Object(DOM event)
     *
     */
    showSearchBoards: function(b) {
        sd = [16, 17, 18, 27, 20];
        nc = [37, 39, 38, 40];
        var self = this;
        if (!(e = b.keyCode, 0 <= checkKeycode(nc, e)) && !(c = b.keyCode, 0 <= checkKeycode(sd, c))) {
            var q = $('#inputBoardSearch').val();
            if (q === '') {
                $('.js-show-add-boards-list').removeClass("pre-scrollable");
                $('js-show-add-boards-list').removeClass("vertical-scrollbar");
                this.$el.find('.js-boards-list-container').nextAll('.js-board-search-result').remove();
                this.showBoardsList(b);
            } else {
                $('.js-show-add-boards-list').addClass("pre-scrollable");
                $('js-show-add-boards-list').addClass("vertical-scrollbar");
                var filtered_boards = App.boards.search(q);
                var boards = new App.BoardCollection();
                if (!_.isEmpty(filtered_boards._wrapped)) {
                    $.unique(filtered_boards._wrapped);
                }
                boards.add(filtered_boards._wrapped);
                var style = '';
                this.$el.find('.js-boards-list-container').nextAll('.js-board-search-result').remove();
                _.each(boards.models, function(board) {
                    if (board.attributes.background_picture_url) {
                        background_picture_url = board.attributes.background_picture_url.replace('_XXXX.jpg', '_b.jpg');
                        style = 'background-image:url(' + board.attributes.background_picture_url + ');';
                    } else if (board.attributes.background_pattern_url) {
                        background_pattern_url = board.attributes.background_pattern_url.replace('_XXXX.jpg', '_n.jpg');
                        style = 'background-image:url(' + background_pattern_url + ');';
                    } else if (board.attributes.background_color) {
                        style = 'background-color:' + board.attributes.background_color + ';';
                    } else {
                        style = '';
                    }

                    $(new App.ShowSearchBoardsView({
                        model: board,
                        style: style,
                        className: 'clearfix js-board-search-result',
                        attributes: {
                            style: style
                        },
                    }).el).insertAfter(self.$el.find('.js-boards-list-container'));

                    $('.js-boards-list-container').append();
                    $('.js-boards-list-container-search').addClass('hide');
                    $('.js-boards-list-container').removeClass('hide');

                });
                if (boards.models.length === 0) {
                    $(new App.ShowSearchBoardsView({
                        model: null,
                        style: style,
                        className: 'clearfix js-board-search-result',
                    }).el).insertAfter(self.$el.find('.js-boards-list-container'));
                }
            }
        }
    },
    /**
     * userActivities()
     * display user activiteis
     * @param e
     * @type Object(DOM event)
     *
     */
    userActivities: function(bool, mode) {
        var self = this;
        var wip_enabled = false;
        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_agile_wip', APPS.enabled_apps) !== -1) {
            wip_enabled = true;
        }
        var activities = new App.ActivityCollection();
        var view_activity = $('#js-all-activities');
        var Auth, favCount;
        var list_notifications_array = ['add_list_color', 'edit_list_color', 'delete_list_color', 'add_card', 'change_list_position', 'archive_list', 'unarchive_list', 'delete_list'];
        var card_notifications_array = ['add_card_color', 'edit_card_color', 'delete_card_color', 'add_card_duedate', 'edit_card_duedate', 'delete_card_duedate', 'move_card', 'archived_card', 'unarchived_card', 'delete_card', 'add_card_desc'];
        var card_members_notifications_array = ['add_card_user', 'delete_card_users'];
        var card_labels_notifications_array = ['add_card_label', 'delete_card_label'];
        var card_checklists_notifications_array = ['add_card_checklist', 'add_checklist_item', 'update_card_checklist', 'update_card_checklist_item', 'delete_checklist_item', 'delete_checklist'];
        var card_attachments_notifications_array = ['add_card_attachment', 'delete_card_attachment'];
        if (!_.isUndefined($.cookie('auth')) && !_.isEmpty($.cookie('auth')) & $.cookie('auth') !== null) {
            Auth = JSON.parse($.cookie('auth'));
            if (_.isUndefined(authuser.user.last_activity_id)) {
                authuser.user.last_activity_id = Auth.user.last_activity_id;
            }
            favCount = parseInt(Auth.user.notify_count);
        }
        var filter = $.cookie('activities_filter');
        if (filter === undefined || filter === 'all') {
            filter = 'all';
        } else if (filter === 'comment') {
            filter = 'comment';
        } else if (filter === 'activity') {
            filter = 'activity';
        }
        if (!_.isUndefined(filter) && filter === 'activity' && !self.$el.find('#modal-activities').hasClass('active')) {
            self.$el.find('#modal-activities').addClass('active');
        } else if (!_.isUndefined(filter) && filter === 'comment' && !self.$el.find('#modal-comments').hasClass('active')) {
            self.$el.find('#modal-comments').addClass('active');
        } else if (_.isUndefined(filter) && !self.$el.find('#modal-activities').hasClass('active') && !self.$el.find('#modal-comments').hasClass('active')) {
            self.$el.find('#modal-activities').addClass('active');
            self.$el.find('#modal-comments').addClass('active');
        }
        if (mode == 1 && !_.isUndefined(authuser) && !_.isUndefined(authuser.user)) {
            query_string = '&last_activity_id=' + authuser.user.last_activity_id + '&direction=ASC';
            activities.url = api_url + 'users/' + authuser.user.id + '/activities.json?type=all' + query_string;
        } else {
            $('#js-activity-loader').remove();
            view_activity.append('<li class="col-xs-12" id="js-activity-loader"><span class="cssloader"></span></li>');
            activities.url = api_url + 'users/' + authuser.user.id + '/activities.json?mode=' + filter;
        }
        var tmp_unreaded_card = {};
        localforage.getItem('unreaded_cards', function(err, value) {
            tmp_unreaded_card = (value !== null && value !== undefined) ? value : tmp_unreaded_card;
            activities.fetch({
                cache: false,
                success: function() {
                    /* if (mode == 1) {
                        activities.setSortField('id', 'asc');
                        activities.sort();
                    } */
                    $('#js-activity-loader').remove();
                    if (!_.isEmpty(activities.models)) {
                        $('#js-load-link').removeClass('hide');
                        var last_activity = _.min(activities.models, function(activity) {
                            return activity.id;
                        });
                        last_user_activity_id = last_activity.id;
                        $('.notification-list').removeClass('notification-empty');
                        $('#js-notification-load-more').removeClass('hide');
                        var count = 0;
                        activities.each(function(activity) {
                            if (activity.attributes.token !== authuser.access_token) {
                                count += 1;
                            }
                        });
                        var update_last_activity = _.max(activities.models, function(activity) {
                            return activity.id;
                        });
                        if (mode == 1 && !_.isUndefined(authuser) && !_.isUndefined(authuser.user)) {
                            favCount += parseInt(count);
                            favicon.badge(favCount);
                            if (parseInt(favCount) > 0) {
                                $('.js-notification-count').removeClass('hide').html(favCount);
                            } else {
                                $('.js-notification-count').addClass('hide');
                            }
                            if ($.cookie('auth')) {
                                Auth = JSON.parse($.cookie('auth'));
                                Auth.user.last_activity_id = (parseInt(Auth.user.last_activity_id) < parseInt(update_last_activity.id)) ? update_last_activity.id : Auth.user.last_activity_id;
                                Auth.user.notify_count = favCount;
                                $.cookie('auth', JSON.stringify(Auth));
                            }
                            authuser.user.last_activity_id = (parseInt(Auth.user.last_activity_id) < parseInt(update_last_activity.id)) ? update_last_activity.id : Auth.user.last_activity_id;
                        } else if (mode == 2 && !_.isUndefined(authuser) && !_.isUndefined(authuser.user)) {
                            if (favCount > 0) {
                                if ($.cookie('auth')) {
                                    Auth = JSON.parse($.cookie('auth'));
                                    var user = new App.User();
                                    user.url = api_url + 'users/' + authuser.user.id + '.json';
                                    user.set('id', parseInt(authuser.user.id));
                                    user.save({
                                        'last_activity_id': (parseInt(Auth.user.last_activity_id) < parseInt(update_last_activity.id)) ? update_last_activity.id : Auth.user.last_activity_id
                                    });
                                    authuser.user.notify_count = 0;
                                    Auth.user.notify_count = 0;
                                    favicon.badge(0);
                                    $('.js-notification-count').addClass('hide');
                                    $.cookie('auth', JSON.stringify(Auth));
                                }
                            }
                        }
                        activities.each(function(activity) {
                            if ($('.js-list-activity-' + activity.id).length > 0) {
                                return true;
                            }
                            var card_id = activity.attributes.card_id,
                                checklist_items, completed_count, total_count, board_id, card, list, removed_list_cards;
                            Auth = JSON.parse($.cookie('auth'));
                            if (_.isUndefined(Auth.user.unread_activity_id) || (parseInt(Auth.user.unread_activity_id) < parseInt(activity.attributes.id))) {
                                if (activity.attributes.token !== authuser.access_token && card_id !== 0) {
                                    if (!_.isUndefined(tmp_unreaded_card) && tmp_unreaded_card !== null && !_.isEmpty(tmp_unreaded_card)) {
                                        if (!_.isUndefined(tmp_unreaded_card[card_id]) && tmp_unreaded_card[card_id] !== null) {
                                            if ((parseInt(Auth.user.unread_activity_id) < parseInt(activity.attributes.id)) || _.isUndefined(Auth.user.unread_activity_id)) {
                                                tmp_unreaded_card[card_id] = tmp_unreaded_card[card_id] + 1;
                                            } else {
                                                tmp_unreaded_card[card_id] = tmp_unreaded_card[card_id];
                                            }
                                        } else {
                                            tmp_unreaded_card[card_id] = 1;
                                        }
                                    } else {
                                        tmp_unreaded_card[card_id] = 1;
                                    }
                                    if (tmp_unreaded_card[card_id] > 0) {
                                        if ($('#js-card-' + card_id).find('.js-unread-notification').length === 0) {
                                            $('#js-card-' + card_id).find('.js-list-card-data').prepend('<li class="js-unread-notification"><small title = "' + i18next.t('unread notifications') + '"><span class="label label-primary"><span class="icon-bell"></span><span>' + tmp_unreaded_card[card_id] + '</span></span></small>');
                                        } else if ($('#js-card-' + card_id).find('.js-unread-notification').length === 1) {
                                            $('#js-card-' + card_id).find('.js-unread-notification').html('<small title = "' + i18next.t('unread notifications') + '"><span class="label label-primary"><span class="icon-bell"></span><span>' + tmp_unreaded_card[card_id] + '</span></span></small>');
                                        }
                                    }
                                }
                            }
                            activity.from_footer = true;
                            activity.attributes.original_comment = activity.attributes.comment;
                            var icon = window.location.pathname + 'img/logo-icon.png';
                            if (activity.attributes.type != 'add_comment' && activity.attributes.type != 'edit_comment') {
                                var cardLink = activity.attributes.card_name;
                                activity.attributes.comment = activity.attributes.comment.replace('##CARD_LINK##', cardLink);
                                activity.attributes.comment = activity.attributes.comment.replace('##ORGANIZATION_LINK##', _.escape(activity.attributes.organization_name));
                                activity.attributes.comment = activity.attributes.comment.replace('##USER_NAME##', _.escape(activity.attributes.full_name));
                                activity.attributes.comment = activity.attributes.comment.replace('##LABEL_NAME##', activity.attributes.label_name);
                                activity.attributes.comment = activity.attributes.comment.replace('##CARD_NAME##', activity.attributes.card_name);
                                activity.attributes.comment = activity.attributes.comment.replace('##DESCRIPTION##', activity.attributes.card_description);
                                activity.attributes.comment = activity.attributes.comment.replace('##LIST_NAME##', activity.attributes.list_name);
                                activity.attributes.comment = activity.attributes.comment.replace('##BOARD_NAME##', activity.attributes.board_name);
                                if (!_.isUndefined(activity.attributes.checklist_name)) {
                                    activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_NAME##', activity.attributes.checklist_name);
                                }
                                if (!_.isUndefined(activity.attributes.checklist_item_name)) {
                                    activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_ITEM_NAME##', activity.attributes.checklist_item_name);
                                }
                                if (!_.isUndefined(activity.attributes.checklist_item_parent_name)) {
                                    activity.attributes.comment = activity.attributes.comment.replace('##CHECKLIST_ITEM_PARENT_NAME##', activity.attributes.checklist_item_parent_name);
                                }
                            } else if (activity.attributes.type === 'add_comment') {
                                activity.set('originial_activity_comment', activity.attributes.comment);
                                activity.attributes.comment = _.escape(activity.attributes.full_name) + ' commented in card ' + activity.attributes.card_name + ' ' + activity.attributes.comment;
                                var matches = activity.attributes.comment.match(/@([^ ]*)/g);
                                var _username = [];
                                _.each(matches, function(match) {
                                    _username.push(match.substr(1));
                                });
                                if (!_.isEmpty(_username) && !_.isUndefined(authuser.user)) {
                                    if (_.contains(_username, authuser.user.username)) {
                                        activity.attributes.comment = _.escape(activity.attributes.full_name) + ' has mentioned you in card ' + activity.attributes.card_name + ' ' + activity.attributes.comment;
                                    } else if (_.contains(_username, 'card')) {
                                        activity.attributes.comment = _.escape(activity.attributes.full_name) + ' has mentioned all the members in the card ' + activity.attributes.card_name + ' ' + activity.attributes.comment;
                                    } else if (_.contains(_username, 'board')) {
                                        activity.attributes.comment = _.escape(activity.attributes.full_name) + ' has mentioned all the board members in the card ' + activity.attributes.card_name + ' ' + activity.attributes.comment;
                                    }
                                }
                            }
                            /* if (mode == 1 && activity.attributes.token !== authuser.access_token) {
                                var user_avatar;
                                var fullname;
                                var notification_link;
                                if (activity.attributes.card_name !== null) {
                                    notification_link = window.location.origin + '/#/board/' + activity.attributes.board_id + '/card/' + activity.attributes.card_id;
                                } else {
                                    notification_link = window.location.origin + '/#/board/' + activity.attributes.board_id;
                                }
                                if (!_.isUndefined(activity.attributes.full_name) && !_.isEmpty(activity.attributes.full_name)) {
                                    fullname = activity.attributes.full_name;
                                } else {
                                    fullname = 'deleted account';
                                }
                                if (!_.isEmpty(activity.attributes.profile_picture_path)) {
                                    user_avatar = window.location.origin + self.model.showImage('User', activity.attributes.user_id, 'small_thumb');
                                } else {
                                    user_avatar = 'https://ui-avatars.com/api/?background=fff&color=f47564&name=' + activity.attributes.initials + '@&size=32';
                                }
                                var s = activity.attributes.created.replace("T", " "),
                                    current_timezone;
                                new_date = moment.tz(s, 'YYYY-MM-DD HH:mm:ss', SITE_TIMEZONE).utc().format('YYYY-MM-DD HH:mm:ss');
                                if (authuser && authuser.user && !_.isUndefined(authuser.user.timezone) && !_.isEmpty(authuser.user.timezone) && authuser.user.timezone !== null) {
                                    current_timezone = moment.tz(authuser.user.timezone).format('Z').replace(':', '');
                                } else {
                                    current_timezone = moment.tz(SITE_TIMEZONE).format('Z').replace(':', '');
                                }
                                tz = moment(new_date + ' Z').utcOffset(current_timezone).format('YYYY-MM-DD HH:mm:ss');
                                if (!moment.isMoment(tz)) {
                                    tz = moment(tz);
                                }
                                tz = tz.format('x');
                                var json_str = JSON.stringify({
                                    "largeIcon": "ic_launcher",
                                    "largeIconUrl": user_avatar,
                                    "smallIcon": "ic_notification",
                                    "title": fullname,
                                    "message": activity.attributes.comment,
                                    "url": notification_link,
                                    "timestamp": tz
                                });
                                try {
                                    window.Android.jsLocalNotification(json_str);
                                } catch (err) {}
                            } */
                            if (typeof Notification != 'undefined') {
                                if (mode == 1 && activity.attributes.token !== authuser.access_token && Notification.permission === 'granted') {
                                    if (!_.isUndefined(authuser) && !_.isUndefined(authuser.user) && authuser.user.default_desktop_notification === true || authuser.user.default_desktop_notification === 'true' || authuser.user.default_desktop_notification === 't') {
                                        var patt_match = activity.attributes.comment.match(/@\w+/g);
                                        if ((authuser.user.is_list_notifications_enabled === true || authuser.user.is_list_notifications_enabled === 'true' || authuser.user.is_list_notifications_enabled === 't') && (jQuery.inArray(activity.attributes.type, list_notifications_array) !== -1)) {
                                            new Notification(activity.attributes.comment, {
                                                icon: icon
                                            });
                                        } else if ((authuser.user.is_card_notifications_enabled === true || authuser.user.is_card_notifications_enabled === 'true' || authuser.user.is_card_notifications_enabled === 't') && (jQuery.inArray(activity.attributes.type, card_notifications_array) !== -1)) {
                                            new Notification(activity.attributes.comment, {
                                                icon: icon
                                            });
                                        } else if ((authuser.user.is_card_members_notifications_enabled === true || authuser.user.is_card_members_notifications_enabled === 'true' || authuser.user.is_card_members_notifications_enabled === 't') && (jQuery.inArray(activity.attributes.type, card_members_notifications_array) !== -1)) {
                                            new Notification(activity.attributes.comment, {
                                                icon: icon
                                            });
                                        } else if ((authuser.user.is_card_labels_notifications_enabled === true || authuser.user.is_card_labels_notifications_enabled === 'true' || authuser.user.is_card_labels_notifications_enabled === 't') && (jQuery.inArray(activity.attributes.type, card_labels_notifications_array) !== -1)) {
                                            new Notification(activity.attributes.comment, {
                                                icon: icon
                                            });
                                        } else if ((authuser.user.is_card_checklists_notifications_enabled === true || authuser.user.is_card_checklists_notifications_enabled === 'true' || authuser.user.is_card_checklists_notifications_enabled === 't') && (jQuery.inArray(activity.attributes.type, card_checklists_notifications_array) !== -1)) {
                                            new Notification(activity.attributes.comment, {
                                                icon: icon
                                            });
                                        } else if ((authuser.user.is_card_attachments_notifications_enabled === true || authuser.user.is_card_attachments_notifications_enabled === 'true' || authuser.user.is_card_attachments_notifications_enabled === 't') && (jQuery.inArray(activity.attributes.type, card_attachments_notifications_array) !== -1)) {
                                            new Notification(activity.attributes.comment, {
                                                icon: icon
                                            });
                                        } else if (!_.isUndefined(patt_match) && !_.isEmpty(patt_match) && patt_match !== null && patt_match.length > 0) {
                                            $.each(patt_match, function(index, user) {
                                                if (user === '@' + authuser.user.username) {
                                                    new Notification(activity.attributes.comment, {
                                                        icon: icon
                                                    });
                                                }
                                            });
                                        }
                                    }
                                }
                            }
                            var view = new App.ActivityView({
                                model: activity,
                                type: 'all',
                                board: self.board,
                                flag: '2'
                            });
                            $('.js-unread-activity').parent().addClass('bg-danger navbar-btn');
                            if (mode == 1) {
                                view_activity.prepend(view.render().el);
                            } else {
                                if ($('.js-list-activity-' + activity.id, view_activity).length === 0) {
                                    view_activity.append(view.render().el);
                                }
                            }
                            if (bool) {
                                if (activity.attributes.token !== authuser.access_token) {
                                    if (!_.isUndefined(activity.attributes.originial_activity_comment) && !_.isEmpty(activity.attributes.originial_activity_comment) && activity.attributes.originial_activity_comment !== null) {
                                        activity.set('comment', activity.attributes.originial_activity_comment);
                                    }
                                    // Update board view code starting
                                    if (!_.isUndefined(self.board)) {
                                        var board_user_role, board_user_role_id;
                                        if (!_.isUndefined(authuser.user)) {
                                            board_user_role = self.board.board_users.findWhere({
                                                user_id: parseInt(authuser.user.id)
                                            });
                                            if (!_.isEmpty(board_user_role)) {
                                                board_user_role_id = board_user_role.attributes.board_user_role_id;
                                            }
                                            if (activity.attributes.type === 'add_permission') {
                                                var isPermissionExist = !_.isEmpty(self.board.acl_links.where({
                                                    slug: activity.attributes.acl_links.slug,
                                                    board_user_role_id: parseInt(board_user_role_id)
                                                }));
                                                if (!isPermissionExist) {
                                                    activity.attributes.acl_links.board_user_role_id = parseInt(activity.attributes.acl_links.board_user_role_id);
                                                    self.board.acl_links.add(activity.attributes.acl_links);
                                                    if (!_.isUndefined(App.current_board)) {
                                                        var permissionExist = !_.isEmpty(App.current_board.acl_links.where({
                                                            slug: activity.attributes.acl_links.slug,
                                                            board_user_role_id: parseInt(board_user_role_id)
                                                        }));
                                                        if (!permissionExist) {
                                                            App.current_board.acl_links.add(activity.attributes.acl_links);
                                                        }
                                                    }
                                                }
                                            } else if (activity.attributes.type === 'remove_permission') {
                                                var acl_link = self.board.acl_links.where({
                                                    slug: activity.attributes.revisions.old_value.slug,
                                                    board_user_role_id: parseInt(activity.attributes.revisions.old_value.role_id)
                                                });
                                                if (!_.isEmpty(acl_link)) {
                                                    self.board.acl_links.remove(acl_link);
                                                    App.current_board.acl_links.remove(acl_link);
                                                }
                                            }
                                        }
                                    }

                                    if (!_.isUndefined(activity.attributes.card_id) && activity.attributes.card_id !== 0 && !_.isUndefined(activity.attributes.board_id) && parseInt(activity.attributes.board_id) === parseInt(self.board_id)) { // Update Card
                                        card = self.board.cards.findWhere({
                                            id: parseInt(activity.attributes.card_id)
                                        });
                                        if (activity.attributes.type === 'add_card' || activity.attributes.type === 'copy_card' || activity.attributes.type === 'convert_card' || (_.isUndefined(card) && activity.attributes.type === 'move_card')) {
                                            if (activity.attributes.type === 'convert_card') {
                                                var checklistItem = self.board.checklist_items.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                });
                                                if (!_.isUndefined(checklistItem) && !_.isEmpty(checklistItem) && checklistItem !== null) {
                                                    var itemCard = self.board.cards.findWhere({
                                                        id: parseInt(checklistItem.attributes.card_id)
                                                    });
                                                    self.board.checklist_items.remove(checklistItem, {
                                                        silent: false
                                                    });
                                                    var totalItems = self.board.checklist_items.where({
                                                        card_id: parseInt(itemCard.id)
                                                    });
                                                    var checklistItems = new App.CheckListItemCollection();
                                                    checklistItems.add(totalItems, {
                                                        silent: true
                                                    });
                                                    var item_completed_count = checklistItems.filter(function(checklist_item) {
                                                        return parseInt(checklist_item.get('is_completed')) === 1;
                                                    }).length;
                                                    var item_total_count = checklistItems.models.length;
                                                    var item_pending_count = item_total_count - item_completed_count;
                                                    itemCard.set('checklist_item_completed_count', item_completed_count);
                                                    itemCard.set('checklist_item_pending_count', item_pending_count);
                                                    itemCard.set('checklist_item_count', item_total_count);
                                                }
                                            }
                                            var new_card = new App.Card();
                                            if (activity.attributes.type === 'add_card' || activity.attributes.type === 'convert_card') {
                                                activity.attributes.card.cards_labels = null;
                                                activity.attributes.card.cards_users = null;
                                                activity.attributes.card.cards_voters = null;
                                            } else {
                                                if (!_.isUndefined(activity.attributes.card.cards_labels) && activity.attributes.card.cards_labels !== null) {
                                                    var card_labels = JSON.parse(activity.attributes.card.cards_labels);
                                                    activity.attributes.card.cards_labels = card_labels;
                                                    var label_count = 1;
                                                    _.each(activity.attributes.card.cards_labels, function(label) {
                                                        var new_label = new App.Label();
                                                        new_label.set(label);
                                                        new_label.set('id', parseInt(label.id));
                                                        new_label.set('label_id', parseInt(label.label_id));
                                                        new_label.set('card_id', parseInt(label.card_id));
                                                        new_label.set('list_id', parseInt(label.list_id));
                                                        new_label.set('board_id', parseInt(label.board_id));
                                                        self.board.labels.add(new_label, {
                                                            silent: true
                                                        });
                                                        var options = {
                                                            silent: true
                                                        };
                                                        if (label_count === activity.attributes.card.cards_labels.length) {
                                                            options.silent = false;
                                                        }
                                                        new_card.labels.add(new_label, options);
                                                        label_count++;
                                                    });
                                                    new_card.set('cards_labels', card_labels);
                                                }
                                                if (!_.isUndefined(activity.attributes.card.cards_users) && activity.attributes.card.cards_users !== null) {
                                                    var cards_users = JSON.parse(activity.attributes.card.cards_users);
                                                    activity.attributes.card.cards_users = cards_users;
                                                }
                                            }
                                            var board_sort_by = (self.board.attributes.sort_by) ? self.board.attributes.sort_by : 'position';
                                            var bard_sort_direction = (self.board.attributes.sort_direction) ? self.board.attributes.sort_direction : 'asc';
                                            activity.attributes.card.is_archived = parseInt(activity.attributes.card.is_archived);
                                            new_card.set(activity.attributes.card);
                                            new_card.set('id', parseInt(activity.attributes.card.id));
                                            new_card.set('board_id', parseInt(activity.attributes.card.board_id));
                                            new_card.set('list_id', parseInt(activity.attributes.card.list_id));
                                            new_card.set('user_id', parseInt(activity.attributes.card.user_id));
                                            new_card.set('is_archived', parseInt(activity.attributes.card.is_archived));
                                            if (activity.attributes.type === 'add_card') {
                                                new_card.set('comment_count', 0);
                                            }
                                            var card_list = self.board.lists.findWhere({
                                                id: parseInt(activity.attributes.card.list_id)
                                            });
                                            if (activity.attributes.type === 'move_card') {
                                                new_card.set('list_moved_date', parseInt(activity.attributes.card.list_moved_date));
                                            }
                                            new_card.list = card_list;
                                            new_card.board = self.board;
                                            if (!_.isEmpty(card_list) && !_.isUndefined(card_list) && card_list !== null && !_.isEmpty(card_list.cards) && !_.isUndefined(card_list.cards) && card_list.cards !== null) {
                                                var tmp_list_cards = card_list.cards;
                                                new_card.set('created', activity.attributes.card.created);
                                                new_card.set('modified', activity.attributes.card.created);
                                                new_card.set('position', parseFloat(activity.attributes.card.position));
                                                tmp_list_cards.add(new_card, {
                                                    silent: true
                                                });
                                                if (board_sort_by !== 'position') {
                                                    var sort_filter_cards = self.cardsort(board_sort_by, bard_sort_direction, tmp_list_cards);
                                                    $.each(sort_filter_cards.models, function(key, filter_card) {
                                                        if (parseInt(filter_card.attributes.is_archived) === 0 && parseInt(filter_card.id) === parseInt(activity.attributes.card.id)) {
                                                            new_card.set('position', key + 1);
                                                        }
                                                    });
                                                }
                                            }

                                            if (!_.isUndefined(card_list) && !_.isUndefined(card_list.attributes.card_count) && card_list.attributes.card_count === 0) {
                                                // Removing the &nbsp; in the card listing after adding card or copy card
                                                $('#js-card-listing-' + card_list.id).find('.js-list-placeholder-' + card_list.id).remove();
                                                /* $('#js-card-listing-' + card_list.id).html(function(i, h) {
                                                    return h.replace(/&nbsp;/g, '');
                                                }); */
                                            }
                                            self.board.cards.add(new_card);
                                            if (!_.isUndefined(card_list) && !_.isUndefined(card_list.cards)) {
                                                card_list.cards.add(new_card);
                                                var card_list_card_count = isNaN(card_list.attributes.card_count) ? 0 : card_list.attributes.card_count;
                                                // Updating the list card count
                                                card_list.set('card_count', parseInt(card_list_card_count) + 1);
                                                if (card_list !== null && !_.isEmpty(card_list) && wip_enabled) {
                                                    $('body').trigger('cardAddRendered', [card_list.id, card_list]);
                                                }
                                            }
                                            if ((!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) && (activity.attributes.type === "copy_card") && !_.isEmpty(activity.attributes.custom_fields) && !_.isUndefined(activity.attributes.custom_fields) && activity.attributes.custom_fields !== null) {
                                                $('body').trigger('CutomFieldsRendered', [parseInt(activity.attributes.card.id), new_card]);
                                            }
                                        }
                                        if (activity.attributes.type === 'add_card_color') {
                                            card.set('color', activity.attributes.color);
                                            self.FilterCards(Backbone.history.fragment.split('?'), card);
                                        }
                                        if (activity.attributes.type === 'edit_card_color') {
                                            card.set('color', activity.attributes.color);
                                            self.FilterCards(Backbone.history.fragment.split('?'), card);
                                        }
                                        if (activity.attributes.type === 'add_card_desc' || activity.attributes.type === 'edit_card_desc') {
                                            card.set('description', activity.attributes.revisions.new_value.description);
                                        }
                                        var current_board_user;
                                        if (!_.isUndefined(authuser.user) && !_.isEmpty(authuser.user) && !_.isUndefined(App.current_board) && !_.isEmpty(App.current_board)) {
                                            current_board_user = App.current_board.board_users.findWhere({
                                                user_id: parseInt(authuser.user.id)
                                            });
                                        }
                                        if (!_.isUndefined(current_board_user) && !_.isEmpty(current_board_user) && current_board_user !== null) {
                                            if (parseInt(current_board_user.attributes.board_user_role_id) === 4) {
                                                // Restricted card users handling
                                                if (activity.attributes.type === 'add_card_user' && _.isUndefined(card)) {
                                                    var listId = parseInt(activity.attributes.list_id);
                                                    $.ajax({
                                                        url: api_url + 'boards/' + parseInt(activity.attributes.board_id) + '/lists/' + listId + '/cards/' + parseInt(activity.attributes.card_id) + '.json?token=' + authuser.access_token,
                                                        cache: false,
                                                        type: 'GET',
                                                        success: function(response) {
                                                            if (!_.isUndefined(response) && response !== null) {
                                                                if (parseInt(response.is_archived) === 0) {
                                                                    var new_card = new App.Card();
                                                                    var board_sort_by = (self.board.attributes.sort_by) ? self.board.attributes.sort_by : 'position';
                                                                    var bard_sort_direction = (self.board.attributes.sort_direction) ? self.board.attributes.sort_direction : 'asc';
                                                                    response.is_archived = parseInt(response.is_archived);
                                                                    var card_checklist_item_count = isNaN(response.checklist_item_count) ? 0 : parseInt(response.checklist_item_count);
                                                                    var card_checklist_item_completed_count = isNaN(response.checklist_item_completed_count) ? 0 : parseInt(response.checklist_item_completed_count);
                                                                    var card_checklist_item_pending_count = card_checklist_item_count - card_checklist_item_completed_count;
                                                                    new_card.set(response);
                                                                    new_card.set({
                                                                        id: parseInt(response.id),
                                                                        board_id: parseInt(response.board_id),
                                                                        list_id: parseInt(response.list_id),
                                                                        created: response.created,
                                                                        modified: response.modified,
                                                                        name: response.name,
                                                                        description: response.description,
                                                                        due_date: response.due_date,
                                                                        is_archived: response.is_archived,
                                                                        attachment_count: parseInt(response.attachment_count),
                                                                        checklist_count: response.checklist_count,
                                                                        checklist_item_count: card_checklist_item_count,
                                                                        checklist_item_completed_count: card_checklist_item_completed_count,
                                                                        checklist_item_pending_count: card_checklist_item_pending_count,
                                                                        card_voter_count: parseInt(response.card_voter_count),
                                                                        position: parseFloat(response.position),
                                                                        user_id: parseInt(response.user_id)
                                                                    });
                                                                    var card_list = self.board.lists.findWhere({
                                                                        id: parseInt(listId)
                                                                    });
                                                                    if (!_.isUndefined(card_list) && !_.isEmpty(card_list) && card_list !== null) {
                                                                        new_card.list = card_list;
                                                                        new_card.board = self.board;
                                                                        if (!_.isEmpty(card_list) && !_.isUndefined(card_list) && card_list !== null && !_.isEmpty(card_list.cards) && !_.isUndefined(card_list.cards) && card_list.cards !== null) {
                                                                            var tmp_list_cards = card_list.cards;
                                                                            tmp_list_cards.add(new_card, {
                                                                                silent: true
                                                                            });
                                                                            if (board_sort_by !== 'position') {
                                                                                var sort_filter_cards = self.cardsort(board_sort_by, bard_sort_direction, tmp_list_cards);
                                                                                $.each(sort_filter_cards.models, function(key, filter_card) {
                                                                                    if (parseInt(filter_card.attributes.is_archived) === 0 && parseInt(filter_card.id) === parseInt(new_card.id)) {
                                                                                        new_card.set('position', key + 1);
                                                                                    }
                                                                                });
                                                                            }
                                                                        }
                                                                    }
                                                                    if (!_.isEmpty(response.cards_users) && !_.isUndefined(response.cards_users) && response.cards_users !== null) {
                                                                        _.each(response.cards_users, function(user) {
                                                                            var new_card_user = new App.CardUser();
                                                                            new_card_user.set(user);
                                                                            new_card_user.set({
                                                                                id: parseInt(user.id),
                                                                                user_id: parseInt(user.user_id),
                                                                                card_id: parseInt(user.card_id),
                                                                                profile_picture_path: user.profile_picture_path,
                                                                                username: user.username,
                                                                                initials: user.initials,
                                                                                full_name: user.full_name
                                                                            });
                                                                            new_card.users.add(new_card_user, {
                                                                                silent: true
                                                                            });
                                                                            new_card.set('users', new_card_user, {
                                                                                silent: true
                                                                            });
                                                                        });
                                                                    }
                                                                    if (!_.isEmpty(response.cards_voters) && !_.isUndefined(response.cards_voters) && response.cards_voters !== null) {
                                                                        new_card.attributes.cards_voters = [];
                                                                        _.each(response.cards_voters, function(voter) {
                                                                            new_card.attributes.cards_voters.push(voter);
                                                                            var new_voter = new App.CardVoter();
                                                                            new_voter.set(voter);
                                                                            new_voter.set({
                                                                                id: parseInt(voter.id),
                                                                                user_id: parseInt(voter.user_id),
                                                                                card_id: parseInt(voter.card_id)
                                                                            });
                                                                            new_card.card_voters.add(new_voter);
                                                                        });
                                                                    }
                                                                    if (!_.isEmpty(response.cards_labels) && !_.isUndefined(response.cards_labels) && response.cards_labels !== null) {
                                                                        _.each(response.cards_labels, function(label) {
                                                                            var new_card_label = new App.Label();
                                                                            new_card_label.set(label);
                                                                            new_card_label.set({
                                                                                id: parseInt(label.id),
                                                                                label_id: parseInt(label.label_id),
                                                                                card_id: parseInt(label.card_id),
                                                                                list_id: parseInt(label.list_id),
                                                                                board_id: parseInt(label.board_id)
                                                                            });
                                                                            self.board.labels.add(new_card_label, {
                                                                                silent: true
                                                                            });
                                                                            var options = {
                                                                                silent: true
                                                                            };
                                                                            new_card.labels.add(new_card_label, options);
                                                                        });
                                                                        new_card.set('cards_labels', response.cards_labels);
                                                                    }
                                                                    if (!_.isEmpty(response.cards_checklists) && !_.isUndefined(response.cards_checklists) && response.cards_checklists !== null) {
                                                                        _.each(response.cards_checklists, function(checklist) {
                                                                            var new_card_checklist = new App.CheckList();
                                                                            new_card_checklist.set(checklist);
                                                                            new_card_checklist.set({
                                                                                id: parseInt(checklist.id),
                                                                                user_id: parseInt(checklist.user_id),
                                                                                card_id: parseInt(checklist.card_id),
                                                                                name: checklist.name,
                                                                                position: checklist.position
                                                                            });
                                                                            self.board.checklists.add(new_card_checklist, {
                                                                                silent: true
                                                                            });
                                                                            if (checklist.checklists_items !== null) {
                                                                                _.each(checklist.checklists_items, function(checklists_item) {
                                                                                    var new_checklist_item = new App.CheckListItem();
                                                                                    new_checklist_item.set(checklists_item);
                                                                                    new_checklist_item.set({
                                                                                        id: parseInt(checklists_item.id),
                                                                                        user_id: parseInt(checklists_item.user_id),
                                                                                        card_id: parseInt(checklists_item.card_id),
                                                                                        checklist_id: parseInt(checklists_item.checklist_id),
                                                                                        position: parseFloat(checklists_item.position),
                                                                                        is_completed: checklists_item.is_completed,
                                                                                        name: checklists_item.name
                                                                                    });
                                                                                    self.board.checklist_items.add(new_checklist_item, {
                                                                                        silent: true
                                                                                    });
                                                                                });
                                                                                checklist_items = self.board.checklist_items.where({
                                                                                    card_id: parseInt(checklist.card_id)
                                                                                });
                                                                                items = new App.CheckListItemCollection();
                                                                                items.add(checklist_items, {
                                                                                    silent: true
                                                                                });
                                                                            }
                                                                        });
                                                                    }
                                                                    if (!_.isUndefined(card_list) && !_.isEmpty(card_list) && card_list !== null && !_.isUndefined(card_list.attributes.card_count) && card_list.attributes.card_count === 0) {
                                                                        // Removing the &nbsp; in the card listing after adding card or copy card
                                                                        $('#js-card-listing-' + card_list.id).find('.js-list-placeholder-' + card_list.id).remove();
                                                                    }
                                                                    if (!_.isUndefined(self.board) && !_.isEmpty(self.board) && self.board !== null && !_.isUndefined(self.board.cards) && !_.isEmpty(self.board.cards) && self.board.cards !== null) {
                                                                        self.board.cards.add(new_card);
                                                                    }
                                                                    if (!_.isUndefined(card_list) && !_.isEmpty(card_list) && card_list !== null && !_.isUndefined(card_list.cards) && !_.isEmpty(card_list.cards) && card_list.cards !== null) {
                                                                        card_list.cards.add(new_card);
                                                                        var card_list_card_count = isNaN(card_list.attributes.card_count) ? 0 : card_list.attributes.card_count;
                                                                        // Updating the list card count
                                                                        card_list.set('card_count', parseInt(card_list_card_count) + 1);
                                                                        if (card_list !== null && !_.isEmpty(card_list) && wip_enabled) {
                                                                            $('body').trigger('cardAddRendered', [card_list.id, card_list]);
                                                                        }
                                                                    }
                                                                    _.each(response.attachments, function(attachment) {
                                                                        var new_card_attachment = new App.CardAttachment();
                                                                        new_card_attachment.set(attachment);
                                                                        new_card_attachment.set({
                                                                            id: parseInt(attachment.id),
                                                                            board_id: parseInt(attachment.board_id),
                                                                            list_id: parseInt(attachment.list_id),
                                                                            card_id: parseInt(attachment.card_id)
                                                                        });
                                                                        if (!_.isUndefined(self.board) && !_.isEmpty(self.board) && self.board !== null && !_.isUndefined(self.board.cards) && !_.isEmpty(self.board.cards) && self.board.cards !== null) {
                                                                            self.board.attachments.unshift(new_card_attachment);
                                                                            var attachment_card = self.board.cards.findWhere({
                                                                                id: parseInt(attachment.card_id)
                                                                            });
                                                                            if (!_.isUndefined(attachment_card) && attachment_card !== null) {
                                                                                attachment_card.attachments.unshift(new_card_attachment);
                                                                            }
                                                                        }
                                                                    });
                                                                    if ((!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null)) {
                                                                        $('body').trigger('CutomFieldsRendered', [parseInt(response.id), new_card]);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    });
                                                } else if (activity.attributes.type === 'delete_card_users' && !_.isUndefined(card)) {
                                                    var cardlist = self.board.lists.findWhere({
                                                        id: parseInt(activity.attributes.list_id)
                                                    });
                                                    cardlist.set('card_count', parseInt(cardlist.attributes.card_count) - 1);
                                                    if (cardlist !== null && !_.isUndefined(cardlist) && !_.isEmpty(cardlist) && wip_enabled) {
                                                        $('body').trigger('cardAddRendered', [cardlist.id, cardlist]);
                                                    }
                                                    if (parseInt(cardlist.attributes.card_count) === 0) {
                                                        if ($('#js-card-listing-' + cardlist.id).length > 0) {
                                                            $('#js-card-listing-' + cardlist.id).find('.js-list-placeholder-' + cardlist.id).remove();
                                                            $('#js-card-listing-' + cardlist.id).html('<span class="js-list-placeholder-' + cardlist.id + '">&nbsp;</span>');
                                                        }
                                                    }
                                                    card.set('is_archived', 1);
                                                    self.board.cards.remove(card, {
                                                        silent: false
                                                    });
                                                }
                                            }
                                        }
                                        if (!_.isUndefined(card)) {
                                            if (activity.attributes.type !== "add_card_evergreen_card" && activity.attributes.type !== "delete_card_evergreen_card") {
                                                card.set('modified', activity.attributes.modified);
                                            }
                                            if ((!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_custom_fields', APPS.enabled_apps)) && (activity.attributes.type === "add_card_custom_field" || activity.attributes.type === "update_card_custom_field" || activity.attributes.type === "delete_card_custom_field") && !_.isEmpty(activity.attributes.custom_fields) && !_.isUndefined(activity.attributes.custom_fields) && activity.attributes.custom_fields !== null) {
                                                $('body').trigger('CutomFieldsRendered', [parseInt(activity.attributes.card_id), card]);
                                            }
                                            if ((!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_gantt_view', APPS.enabled_apps)) && (activity.attributes.type === "add_card_dependency" || activity.attributes.type === "delete_card_dependency")) {
                                                $('body').trigger('DependencyRendered', [activity.attributes, card]);
                                            }
                                            if (activity.attributes.type === 'add_card_duedate') {
                                                card.set('end', activity.attributes.revisions.new_value.due_date);
                                                card.set('start', activity.attributes.revisions.new_value.due_date);
                                                card.set('due_date', activity.attributes.revisions.new_value.due_date);
                                                if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_gantt_view', APPS.enabled_apps) && !_.isUndefined(activity.attributes.child_cards) && !_.isEmpty(activity.attributes.child_cards) && activity.attributes.child_cards !== null) {
                                                    $('body').trigger('DependencyRendered', [activity.attributes, card]);
                                                }
                                                self.FilterCards(Backbone.history.fragment.split('?'), card);
                                            } else if (activity.attributes.type === 'edit_card_duedate') {
                                                card.set('end', activity.attributes.revisions.new_value.due_date);
                                                card.set('start', activity.attributes.revisions.new_value.due_date);
                                                card.set('due_date', activity.attributes.revisions.new_value.due_date);
                                                if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_gantt_view', APPS.enabled_apps) && !_.isUndefined(activity.attributes.child_cards) && !_.isEmpty(activity.attributes.child_cards) && activity.attributes.child_cards !== null) {
                                                    $('main').trigger('dueDateRendered', activity.attributes.child_cards);
                                                }
                                                self.FilterCards(Backbone.history.fragment.split('?'), card);
                                            } else if (activity.attributes.type === 'delete_card_duedate') {
                                                card.set('end', activity.attributes.revisions.new_value.due_date);
                                                card.set('start', activity.attributes.revisions.new_value.due_date);
                                                card.set('due_date', null);
                                                self.FilterCards(Backbone.history.fragment.split('?'), card);
                                            }
                                            if (!_.isEmpty(activity.attributes.revisions) && activity.attributes.type !== 'update_card_checklist' && activity.attributes.type !== 'move_card' && activity.attributes.type !== 'update_card_checklist_item') {
                                                if (!_.isUndefined(activity.attributes.revisions.new_value) && activity.attributes.revisions.new_value !== null) {
                                                    if (activity.attributes.revisions.new_value.card_id) {
                                                        activity.attributes.revisions.new_value.id = parseInt(activity.attributes.revisions.new_value.card_id);
                                                    }
                                                    if (activity.attributes.revisions.new_value.board_id) {
                                                        activity.attributes.revisions.new_value.board_id = parseInt(activity.attributes.revisions.new_value.board_id);
                                                    }
                                                    if (activity.attributes.revisions.new_value.list_id) {
                                                        activity.attributes.revisions.new_value.list_id = parseInt(activity.attributes.revisions.new_value.list_id);
                                                    }
                                                    if (activity.attributes.type === "archived_card") {
                                                        card.set('modified', activity.attributes.created);
                                                    }
                                                    card.set(activity.attributes.revisions.new_value);
                                                }
                                            }
                                            if ((!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) && (activity.attributes.type === "add_card_estimatedtime" || activity.attributes.type === "edit_card_estimatedtime" || activity.attributes.type === "delete_card_estimatedtime" || activity.attributes.type === "add_card_spenttime" || activity.attributes.type === "edit_card_spenttime" || activity.attributes.type === "delete_card_spenttime" || activity.attributes.type === "add_card_startdate" || activity.attributes.type === "edit_card_startdate" || activity.attributes.type === "delete_card_startdate") && !_.isEmpty(activity.attributes.revisions.new_value.custom_fields)) {
                                                $('body').trigger('cardCutomFieldsRendered', [parseInt(activity.attributes.revisions.new_value.id), card]);
                                            }
                                            if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && (activity.attributes.type === "add_card_evergreen_card" || activity.attributes.type === "delete_card_evergreen_card") && !_.isEmpty(activity.attributes.revisions.new_value.custom_fields)) {
                                                $('body').trigger('cardAgingRendered', [parseInt(card.id), card]);
                                            }
                                            if (activity.attributes.type === 'add_card_checklist') {
                                                var new_checklist = new App.CheckList();
                                                new_checklist.set(activity.attributes.checklist);
                                                new_checklist.set('id', parseInt(activity.attributes.checklist.id));
                                                new_checklist.set('user_id', parseInt(activity.attributes.checklist.user_id));
                                                new_checklist.set('card_id', parseInt(activity.attributes.checklist.card_id));
                                                self.board.checklists.add(new_checklist, {
                                                    silent: false
                                                });
                                                if (activity.attributes.checklist.checklists_items !== null) {
                                                    _.each(activity.attributes.checklist.checklists_items, function(checklists_item) {
                                                        var new_item = new App.CheckListItem();
                                                        new_item.set(checklists_item);
                                                        new_item.set('id', parseInt(checklists_item.id));
                                                        new_item.set('user_id', parseInt(checklists_item.user_id));
                                                        new_item.set('card_id', parseInt(checklists_item.card_id));
                                                        new_item.set('checklist_id', parseInt(checklists_item.checklist_id));
                                                        new_item.set('position', parseFloat(checklists_item.position));
                                                        self.board.checklist_items.add(new_item);
                                                    });
                                                    checklist_items = self.board.checklist_items.where({
                                                        card_id: parseInt(activity.attributes.checklist.card_id)
                                                    });
                                                    items = new App.CheckListItemCollection();
                                                    items.add(checklist_items);
                                                    completed_count = items.filter(function(checklist_item) {
                                                        return parseInt(checklist_item.get('is_completed')) === 1;
                                                    }).length;
                                                    total_count = items.models.length;
                                                    var pending_cnt = total_count - completed_count;
                                                    card.set('checklist_item_pending_count', pending_cnt);
                                                    card.set('checklist_item_completed_count', completed_count);
                                                    card.set('checklist_item_count', total_count);
                                                }
                                            } else if (activity.attributes.type === 'add_card_label' || activity.attributes.type === 'update_card_label') {
                                                var filtered_labels = self.board.labels.where({
                                                    card_id: activity.attributes.card_id
                                                });
                                                self.board.labels.remove(filtered_labels, {
                                                    silent: true
                                                });
                                                card.labels.remove(filtered_labels, {
                                                    silent: true
                                                });
                                                var i = 1;
                                                _.each(activity.attributes.labels, function(label) {
                                                    var new_label = new App.Label();
                                                    new_label.set(label);
                                                    new_label.set('id', parseInt(label.id));
                                                    new_label.set('label_id', parseInt(label.label_id));
                                                    new_label.set('card_id', parseInt(label.card_id));
                                                    new_label.set('list_id', parseInt(label.list_id));
                                                    new_label.set('board_id', parseInt(label.board_id));
                                                    self.board.labels.add(new_label, {
                                                        silent: true
                                                    });
                                                    var options = {
                                                        silent: true
                                                    };
                                                    if (i === activity.attributes.labels.length) {
                                                        options.silent = false;
                                                    }
                                                    card.labels.add(new_label, options);
                                                    i++;
                                                });
                                                card.set('cards_labels', activity.attributes.labels);
                                                self.FilterCards(Backbone.history.fragment.split('?'), card);
                                            } else if (activity.attributes.type === 'delete_card_label') {
                                                var remove_labels = self.board.labels.where({
                                                    card_id: activity.attributes.card_id
                                                });
                                                self.board.labels.remove(remove_labels, {
                                                    silent: true
                                                });
                                                card.labels.remove(remove_labels, {
                                                    silent: true
                                                });
                                                card.set('cards_labels', null);
                                                self.FilterCards(Backbone.history.fragment.split('?'), card);
                                            } else if (activity.attributes.type === 'add_card_voter') {
                                                if (_.isUndefined(card.attributes.cards_voters) || card.attributes.cards_voters === null) {
                                                    card.set('cards_voters', []);
                                                }
                                                if (activity.attributes.voter !== false) {
                                                    card.attributes.cards_voters.push(activity.attributes.voter);
                                                    var new_voter = new App.CardVoter();
                                                    new_voter.set(activity.attributes.voter);
                                                    new_voter.set('id', parseInt(activity.attributes.voter.id));
                                                    new_voter.set('user_id', parseInt(activity.attributes.voter.user_id));
                                                    new_voter.set('card_id', parseInt(activity.attributes.voter.card_id));
                                                    card.card_voters.add(new_voter);
                                                    var add_card_voter_count = isNaN(card.attributes.card_voter_count) ? 0 : card.attributes.card_voter_count;
                                                    add_card_voter_count = add_card_voter_count + 1;
                                                    card.set('card_voter_count', add_card_voter_count);
                                                }
                                            } else if (activity.attributes.type === 'add_card_voter') {
                                                card.set('cards_users', activity.attributes.user);
                                            } else if (activity.attributes.type === 'add_checklist_item') {
                                                var new_item = new App.CheckListItem();
                                                new_item.set(activity.attributes.item, {
                                                    silent: true
                                                });
                                                new_item.set('id', parseInt(activity.attributes.item.id));
                                                new_item.set('user_id', parseInt(activity.attributes.item.user_id));
                                                new_item.set('card_id', parseInt(activity.attributes.item.card_id));
                                                new_item.set('checklist_id', parseInt(activity.attributes.item.checklist_id));
                                                new_item.set('position', parseFloat(activity.attributes.item.position));
                                                self.board.checklist_items.add(new_item, {
                                                    silent: false
                                                });
                                                var added_checklist_items = self.board.checklist_items.where({
                                                    card_id: parseInt(activity.attributes.card_id)
                                                });
                                                items = new App.CheckListItemCollection();
                                                items.add(added_checklist_items, {
                                                    silent: true
                                                });
                                                var added_completed_count = items.filter(function(checklist_item) {
                                                    return parseInt(checklist_item.get('is_completed')) === 1;
                                                }).length;
                                                var added_total_count = items.models.length;
                                                var added_pending_cnt = added_total_count - added_completed_count;
                                                card.set('checklist_item_completed_count', added_completed_count, {
                                                    silent: false
                                                });
                                                card.set('checklist_item_pending_count', added_pending_cnt, {
                                                    silent: false
                                                });
                                                card.set('checklist_item_count', added_total_count, {
                                                    silent: false
                                                });
                                            } else if (activity.attributes.type === 'update_card_checklist') {
                                                checklist = self.board.checklists.findWhere({
                                                    id: parseInt(activity.attributes.checklist.id)
                                                });
                                                if (!_.isUndefined(checklist)) {
                                                    checklist.set(activity.attributes.checklist);
                                                    checklist.set('id', parseInt(activity.attributes.checklist.id));
                                                    checklist.set('user_id', parseInt(activity.attributes.checklist.user_id));
                                                    checklist.set('card_id', parseInt(activity.attributes.checklist.card_id));
                                                    checklist.set('position', parseFloat(activity.attributes.checklist.position));
                                                    card.checklists.set(activity.attributes.checklist);
                                                }
                                            } else if (activity.attributes.type === 'update_card_checklist_item' || activity.attributes.type === 'moved_card_checklist_item') {
                                                var checklist_item = self.board.checklist_items.findWhere({
                                                    id: parseInt(activity.attributes.item.id)
                                                });
                                                if (!_.isUndefined(checklist_item)) {
                                                    var options = {
                                                        silent: false
                                                    };
                                                    checklist_item.set(activity.attributes.item, options);
                                                    $('#js-checklist-item-' + activity.attributes.item.id).html(self.converter.makeHtml(activity.attributes.item.name));
                                                    checklist_item.set('id', parseInt(activity.attributes.item.id));
                                                    checklist_item.set('user_id', parseInt(activity.attributes.item.user_id));
                                                    checklist_item.set('card_id', parseInt(activity.attributes.item.card_id));
                                                    checklist_item.set('checklist_id', parseInt(activity.attributes.item.checklist_id));
                                                    checklist_item.set('position', parseFloat(activity.attributes.item.position));
                                                    var is_completed = (activity.attributes.item.is_completed === 't') ? 1 : 0;
                                                    checklist_item.set('is_completed', is_completed, options);
                                                    checklist_items = self.board.checklist_items.where({
                                                        card_id: parseInt(activity.attributes.card_id)
                                                    });
                                                    items = new App.CheckListItemCollection();
                                                    items.add(checklist_items, options);
                                                    completed_count = items.filter(function(checklist_item) {
                                                        return ((parseInt(checklist_item.get('is_completed')) === 1) || ((checklist_item.get('is_completed')) === 't'));
                                                    }).length;
                                                    total_count = items.models.length;
                                                    var updated_pending_cnt = total_count - completed_count;
                                                    card.set('checklist_item_pending_count', updated_pending_cnt);
                                                    card.set('checklist_item_completed_count', completed_count);
                                                    card.set('checklist_item_count', total_count);
                                                }
                                            } else if (activity.attributes.type === 'edit_comment') {
                                                comment = self.board.activities.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                });
                                                if (!_.isUndefined(comment)) {
                                                    var comment_value = self.converter.makeHtml(activity.attributes.revisions.new_value.comment);
                                                    comment.set(activity);
                                                    comment.set('id', parseInt(activity.attributes.foreign_id));
                                                    comment.set('user_id', parseInt(activity.attributes.user_id));
                                                    comment.set('card_id', parseInt(activity.attributes.card_id));
                                                    $('.js-activity-' + activity.attributes.foreign_id).find('.github-markdown').html(comment_value);
                                                }
                                            } else if (activity.attributes.type === 'add_card_user') {
                                                if (activity.attributes.user !== false) {
                                                    var new_user = new App.CardUser();
                                                    new_user.set(activity.attributes.user);
                                                    new_user.set('id', parseInt(activity.attributes.user.id));
                                                    new_user.set('user_id', parseInt(activity.attributes.user.user_id));
                                                    new_user.set('card_id', parseInt(activity.attributes.user.card_id));
                                                    new_user.set('profile_picture_path', activity.attributes.user.profile_picture_path);
                                                    new_user.set('username', activity.attributes.user.username);
                                                    new_user.set('initials', activity.attributes.user.initials);
                                                    new_user.set('full_name', activity.attributes.user.full_name);
                                                    card.users.add(new_user);
                                                    card.set('users', new_user);
                                                    self.FilterCards(Backbone.history.fragment.split('?'), card);
                                                }
                                            } else if (activity.attributes.type === 'add_comment') {
                                                if (!_.isEmpty(card.cards)) {
                                                    activity.cards.add(card.cards);
                                                }
                                                if (!_.isUndefined(card.list)) {
                                                    card.list.collection.board.activities.add(activity);
                                                }
                                                if (!_.isUndefined(card.activities) && !_.isEmpty(card.activities) && card.activities !== null) {
                                                    card.activities.add(activity, {
                                                        silent: true
                                                    });
                                                }
                                                if (!_.isUndefined(card.list)) {
                                                    var current_card = card.list.collection.board.cards.get(activity.attributes.card_id);
                                                    var comment_count = (!_.isUndefined(current_card)) ? (parseInt(current_card.attributes.comment_count) + 1) : 0;
                                                    comment_count = isNaN(comment_count) ? 1 : comment_count;
                                                    card.set('comment_count', comment_count);
                                                    card.attributes.comment_count = comment_count;
                                                }
                                                if ($('#js-card-modal-' + activity.attributes.card_id).length === 1) {
                                                    if ($('#js-card-activities-' + activity.attributes.card_id).length === 1) {
                                                        if ($('#js-card-activities-' + activity.attributes.card_id + ' ' + '.js-list-activity-' + activity.attributes.id).length === 0) {
                                                            var profile_picture_path;
                                                            var comment_details;
                                                            var profile_picture;
                                                            var depth;
                                                            if (!_.isEmpty(activity.attributes.profile_picture_path)) {
                                                                profile_picture_path = activity.showImage('User', activity.attributes.user_id, 'small_thumb');
                                                                profile_picture = '<img src="' + profile_picture_path + '" alt="[Image: ' + activity.attributes.full_name + ']" title="' + activity.attributes.full_name + ' (' + activity.attributes.username + ')" class="img-rounded img-responsive">';
                                                            } else {
                                                                profile_picture = '<i class="avatar avatar-color-194 img-rounded">' + activity.attributes.initials + '</i>';
                                                            }
                                                            if (!_.isEmpty(activity.attributes.comment)) {
                                                                comment_details = makeLink(self.converter.makeHtml(activity.attributes.comment), activity.attributes.board_id);
                                                            }
                                                            if (activity.attributes.depth !== 0) {
                                                                depth = parseInt(activity.attributes.depth);
                                                            } else {
                                                                depth = '';
                                                            }
                                                            var comment_string = '';
                                                            comment_string += '<li class="col-xs-' + (12 - depth) + ' js-activity activity-github-styles js-list-activity-' + activity.attributes.id + ' col-lg-offset-' + depth + '"><div class="media  modal-comments modal-logged-user-activities"><a title="' + activity.attributes.full_name + '(' + activity.attributes.username + ')" data-toggle="tooltip" class="js-tooltip pull-left" href="#/user/' + activity.attributes.user_id + '">';
                                                            comment_string += '' + profile_picture + '</a>';
                                                            comment_string += '<div class="media-body"><div class="col-xs-12 btn-block"><div class="activities-list js-activity-' + activity.attributes.id + '"><div class="panel no-mar"><div class="panel-body github-markdown no-whitespace">' + comment_details + '</div></div>';
                                                            comment_string += '<small><span class="js-timeago-' + activity.attributes.id + '"></span>';
                                                            if (!_.isUndefined(authuser.user) && !_.isEmpty(authuser.user)) {
                                                                comment_string += '<div class="js-acticity-action-' + activity.attributes.id + ' pull-left navbar-btn col-md-10 col-xs-12"><ul class="list-inline">';
                                                                var user = card.list.collection.board.board_users.findWhere({
                                                                    user_id: parseInt(authuser.user.id)
                                                                });
                                                                if (authuser.user.role_id == 1 || ((!_.isEmpty(card.list.collection.board.acl_links.where({
                                                                        slug: "comment_card",
                                                                        board_user_role_id: parseInt(user.attributes.board_user_role_id)
                                                                    }))) || (!_.isEmpty(role_links.where({
                                                                        slug: "comment_card"
                                                                    })) && card.list.collection.board.attributes.board_visibility == 2))) {
                                                                    comment_string += '<li><a title="Reply" class="js-show-reply-activity-form js-reply-activity-link-' + activity.attributes.id + '" href="#" data-activity-id="' + activity.attributes.id + '"><i class="icon-repeat"></i>' + i18next.t('Reply') + '</a></li>';
                                                                }
                                                                if (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({
                                                                        slug: "delete_comment",
                                                                        board_user_role_id: parseInt(user.attributes.board_user_role_id)
                                                                    }))) {
                                                                    comment_string += '<li class="dropdown pull-right"><a title="Delete" class="dropdown-toggle js-show-confirm-comment-delete text-danger" data-toggle="dropdown" href="#" data-activity-id="' + activity.attributes.id + '" role="button"><i class="icon-remove"></i>' + i18next.t('Delete') + '</a>';
                                                                    comment_string += '<ul class="dropdown-menu arrow arrow-right"><li id="js-acticity-actions-response-' + activity.attributes.id + '" class="js-dropdown-popup dropdown-popup"></li></ul></li>';
                                                                }
                                                                if (authuser.user.role_id == 1 || !_.isEmpty(card.list.collection.board.acl_links.where({
                                                                        slug: "edit_comment",
                                                                        board_user_role_id: parseInt(user.attributes.board_user_role_id)
                                                                    }))) {
                                                                    comment_string += '<li class="pull-right"><a title="Edit" class="js-show-edit-activity js-edit-activity-link-' + activity.attributes.id + '" href="#" data-activity-id="' + activity.attributes.id + '" data-activity-temp-id="' + activity.attributes.temp_id + '"><i class="icon-edit"></i>' + i18next.t('Edit') + '</a></li>';
                                                                }
                                                                comment_string += '</ul>';
                                                                comment_string += '</div><span class="pull-left col-xs-12 js-activity-reply-form-response-' + activity.attributes.id + '"></span></small></div></div></div></div><hr class="clearfix col-xs-12 btn-block"></hr></li>';
                                                                if (activity.attributes.depth === 0) {
                                                                    $("ul#js-card-activities-" + activity.attributes.card_id).prepend(comment_string);
                                                                } else {
                                                                    if (activity.attributes.depth == 1) {
                                                                        $(comment_string).insertAfter($('.js-list-activity-' + activity.attributes.root));
                                                                    } else {
                                                                        var path = activity.attributes.path;
                                                                        var pathSplit = path.split('.');
                                                                        --depth;
                                                                        var parentCommentId = pathSplit[depth].replace('P', '');
                                                                        $(comment_string).insertAfter($('.js-list-activity-' + parentCommentId));
                                                                    }
                                                                }
                                                                setInterval(function() {
                                                                    parse_date(activity.attributes.created, authuser, 'js-timeago-' + activity.attributes.id);
                                                                }, 10000);
                                                                parse_date(activity.attributes.created, authuser, 'js-timeago-' + activity.attributes.id);
                                                                emojify.run();
                                                            }
                                                        }
                                                    }
                                                }
                                            } else if (activity.attributes.type === 'add_card_attachment') {
                                                var previous_attachment_count = isNaN(card.attributes.attachment_count) ? 0 : card.attributes.attachment_count;
                                                var new_attachment = new App.CardAttachment();
                                                new_attachment.set(activity.attributes.attachment);
                                                new_attachment.set('id', parseInt(activity.attributes.attachment.id));
                                                new_attachment.set('board_id', parseInt(activity.attributes.attachment.board_id));
                                                new_attachment.set('list_id', parseInt(activity.attributes.attachment.list_id));
                                                new_attachment.set('card_id', parseInt(activity.attributes.attachment.card_id));
                                                self.board.attachments.unshift(new_attachment, {
                                                    silent: true
                                                });
                                                card.set('attachment_count', previous_attachment_count + 1);
                                                card.attachments.unshift(new_attachment);
                                            } else if (activity.attributes.type === 'move_card') {
                                                // Getting the old list of the card
                                                var card_old_list = self.board.lists.findWhere({
                                                    id: parseInt(activity.attributes.list_id)
                                                });
                                                var card_new_list = self.board.lists.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                });
                                                var tmp_sort_by = (self.board.attributes.sort_by) ? self.board.attributes.sort_by : 'position';
                                                var tmp_sort_direction = (self.board.attributes.sort_direction) ? self.board.attributes.sort_direction : 'asc';
                                                if (!_.isEmpty(card_new_list) && !_.isUndefined(card_new_list) && card_new_list !== null && !_.isEmpty(card_new_list.cards) && !_.isUndefined(card_new_list.cards) && card_new_list.cards !== null) {
                                                    var tmp_newlist_cards = card_new_list.cards;
                                                    card.set('created', card.get('created'));
                                                    card.set('modified', activity.attributes.created);
                                                    card.set('list_moved_date', activity.attributes.created);
                                                    card.set('list_name', activity.attributes.moved_list_name, {
                                                        silent: true
                                                    });
                                                    card.list_name = activity.attributes.moved_list_name;
                                                    card.set('position', parseFloat(activity.attributes.card_position));
                                                    tmp_newlist_cards.add(card, {
                                                        silent: true
                                                    });
                                                    if (tmp_sort_by !== 'position') {
                                                        var new_sort_filter_cards = self.cardsort(tmp_sort_by, tmp_sort_direction, tmp_newlist_cards);
                                                        $.each(new_sort_filter_cards.models, function(key, filter_card) {
                                                            if (parseInt(filter_card.attributes.is_archived) === 0 && parseInt(filter_card.id) === parseInt(card.id)) {
                                                                card.set('position', key);
                                                            }
                                                        });
                                                    }
                                                }
                                                if (!_.isUndefined(App.boards) && !_.isUndefined(App.boards.get(parseInt(activity.attributes.board_id)))) {
                                                    var updated_card_list_cards = self.board.cards.where({
                                                        list_id: parseInt(activity.attributes.list_id)
                                                    });
                                                    if (!_.isUndefined(card.list.collection) && !_.isEmpty(card.list.collection) && card.list.collection !== null) {
                                                        var cards_list = card.list.collection.board.lists.get(parseInt(activity.attributes.list_id));
                                                        if (!_.isUndefined(cards_list) && cards_list !== null) {
                                                            cards_list.cards.remove(card);
                                                        }
                                                    }
                                                }
                                                // Reducing the card count of the old list
                                                if (!_.isEmpty(card_old_list) && !_.isUndefined(card_old_list) && card_old_list !== null) {
                                                    var card_old_list_card_count = isNaN(card_old_list.attributes.card_count) ? 0 : card_old_list.attributes.card_count;
                                                    if (!isNaN(card_old_list_card_count) && parseInt(card_old_list_card_count) !== 0 && card_old_list_card_count !== null) {
                                                        card_old_list.set('card_count', parseInt(card_old_list_card_count) - 1);
                                                    }
                                                    if (parseInt(card_old_list.attributes.card_count) === 0) {
                                                        // Adding the &nbsp; for the list with no card
                                                        $('#js-card-listing-' + card_old_list.id).find('.js-list-placeholder-' + card_old_list.id).remove();
                                                        $('#js-card-listing-' + card_old_list.id).html('<span class="js-list-placeholder-' + card_old_list.id + '">&nbsp;</span>');
                                                        // $('#js-card-listing-' + card_old_list.id).html('&nbsp;');
                                                    }
                                                }
                                                // Updating the new list card count
                                                if (!_.isEmpty(card_new_list) && !_.isUndefined(card_new_list) && card_new_list !== null && !_.isEmpty(card_new_list.cards) && !_.isUndefined(card_new_list.cards) && card_new_list.cards !== null) {

                                                    var card_new_list_card_count = isNaN(card_new_list.attributes.card_count) ? 0 : card_new_list.attributes.card_count;
                                                    card_new_list.set('card_count', parseInt(card_new_list_card_count) + 1);
                                                    if (parseInt(card_new_list.attributes.card_count) === 1) {
                                                        // Removing the &nbsp; fom new lsit card listing 
                                                        $('#js-card-listing-' + card_new_list.id).find('.js-list-placeholder-' + card_new_list.id).remove();
                                                    }
                                                    if (!_.isUndefined(card_old_list) && !_.isUndefined(card_new_list) && wip_enabled) {
                                                        $('body').trigger('cardSortRendered', [card_old_list, card_new_list]);
                                                    }
                                                    card.list = card_new_list;
                                                }
                                                card.set('list_id', parseInt(activity.attributes.foreign_id));
                                                if (!_.isUndefined(card.list.collection) && !_.isEmpty(card.list.collection) && card.list.collection !== null) {
                                                    card.list.collection.board.lists.get(activity.attributes.foreign_id).cards.add(card);
                                                }
                                                var cards_attachments = self.board.attachments.where({
                                                    card_id: parseInt(activity.attributes.card_id)
                                                });
                                                var k = 1;
                                                if (!_.isUndefined(cards_attachments) && cards_attachments.length > 0) {
                                                    _.each(cards_attachments, function(cards_attachment) {
                                                        var options = {
                                                            silent: true
                                                        };
                                                        if (k === cards_attachments.length) {
                                                            options.silent = false;
                                                        }
                                                        self.board.attachments.findWhere({
                                                            id: parseInt(cards_attachment.attributes.id)
                                                        }).set({
                                                            list_id: parseInt(activity.attributes.foreign_id)
                                                        }, options);
                                                        k++;
                                                    });
                                                }
                                            } else if (activity.attributes.type === 'archived_card') {
                                                var Cardlist = self.board.lists.findWhere({
                                                    id: parseInt(activity.attributes.list_id)
                                                });
                                                Cardlist.set('card_count', parseInt(Cardlist.attributes.card_count) - 1);
                                                if (Cardlist !== null && !_.isUndefined(Cardlist) && !_.isEmpty(Cardlist) && wip_enabled) {
                                                    $('body').trigger('cardAddRendered', [Cardlist.id, Cardlist]);
                                                }
                                                if (parseInt(Cardlist.attributes.card_count) === 0) {
                                                    if ($('#js-card-listing-' + Cardlist.id).length > 0) {
                                                        $('#js-card-listing-' + Cardlist.id).find('.js-list-placeholder-' + Cardlist.id).remove();
                                                        $('#js-card-listing-' + Cardlist.id).html('<span class="js-list-placeholder-' + Cardlist.id + '">&nbsp;</span>');
                                                    }
                                                }
                                            } else if (activity.attributes.type === 'unarchived_card') {
                                                var cardList = self.board.lists.get(activity.attributes.list_id);
                                                if (cardList !== null && !_.isUndefined(cardList) && !_.isEmpty(cardList) && wip_enabled) {
                                                    cardList.set('card_count', parseInt(cardList.attributes.card_count) + 1);
                                                    $('body').trigger('cardAddRendered', [cardList.id, cardList]);
                                                }
                                                if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_gantt_view', APPS.enabled_apps) !== -1) {
                                                    $('body').trigger('GanttFilterRendered');
                                                }
                                                if (parseInt(cardList.attributes.card_count) === 1) {
                                                    if ($('#js-card-listing-' + cardList.id).length > 0) {
                                                        $('#js-card-listing-' + cardList.id).find('.js-list-placeholder-' + cardList.id).remove();
                                                    }
                                                }
                                            } else if (activity.attributes.type === 'change_card_position') {
                                                card.set('position', activity.attributes.card_position);
                                            } else if (activity.attributes.type === 'delete_card_attachment') {
                                                var previous_attachment = card.attributes.attachment_count;
                                                self.board.attachments.remove(self.board.attachments.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                }));
                                                card.attachments.remove(card.attachments.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                }));
                                                card.set('attachment_count', previous_attachment - 1);
                                                $('.js-card-attachment-' + activity.attributes.board_id + '-' + activity.attributes.foreign_id).remove();
                                            } else if (activity.attributes.type === 'delete_card_comment') {
                                                self.board.activities.remove(self.board.activities.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                }));
                                                if (!_.isUndefined(card.activities) && !_.isEmpty(card.activities) && card.activities !== null) {
                                                    card.activities.remove(card.activities.findWhere({
                                                        id: parseInt(activity.attributes.foreign_id)
                                                    }));
                                                }
                                                if ($('.js-list-activity-' + activity.attributes.foreign_id)) {
                                                    $('.js-list-activity-' + activity.attributes.foreign_id).remove();
                                                }
                                                var comment_card = card.list.collection.board.cards.get(activity.attributes.card_id);
                                                var tmp_comment_count = (!_.isUndefined(comment_card)) ? (parseInt(comment_card.attributes.comment_count) - 1) : 0;
                                                card.set('comment_count', tmp_comment_count);
                                            } else if (activity.attributes.type === 'delete_checklist') {
                                                self.board.checklists.remove(self.board.checklists.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                }), {
                                                    silent: false
                                                });
                                                self.board.checklist_items.remove(self.board.checklist_items.where({
                                                    checklist_id: parseInt(activity.attributes.foreign_id)
                                                }), {
                                                    silent: false
                                                });
                                                checklist_items = self.board.checklist_items.where({
                                                    card_id: parseInt(activity.attributes.card_id)
                                                });
                                                items = new App.CheckListItemCollection();
                                                items.add(checklist_items, {
                                                    silent: true
                                                });
                                                completed_count = items.filter(function(checklist_item) {
                                                    return parseInt(checklist_item.get('is_completed')) === 1;
                                                }).length;
                                                total_count = items.models.length;
                                                var pending_count = total_count - completed_count;
                                                card.set('checklist_item_completed_count', completed_count);
                                                card.set('checklist_item_pending_count', pending_count);
                                                card.set('checklist_item_count', total_count);
                                            } else if (activity.attributes.type === 'delete_checklist_item') {
                                                self.board.checklist_items.remove(self.board.checklist_items.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                }), {
                                                    silent: false
                                                });
                                                var update_checklist_items = self.board.checklist_items.where({
                                                    card_id: parseInt(activity.attributes.card_id)
                                                });
                                                items = new App.CheckListItemCollection();
                                                items.add(update_checklist_items, {
                                                    silent: true
                                                });
                                                var update_completed_count = items.filter(function(checklist_item) {
                                                    return parseInt(checklist_item.get('is_completed')) === 1;
                                                }).length;
                                                var update_total_count = items.models.length;
                                                var update_pending_count = update_total_count - update_completed_count;
                                                card.set('checklist_item_completed_count', update_completed_count);
                                                card.set('checklist_item_pending_count', update_pending_count);
                                                card.set('checklist_item_count', update_total_count);
                                            } else if (activity.attributes.type === 'delete_card_users') {
                                                card.users.remove(card.users.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                }));
                                                self.FilterCards(Backbone.history.fragment.split('?'), card);
                                            } else if (activity.attributes.type === 'unvote_card') {
                                                var voted_user = card.card_voters.findWhere({
                                                    card_id: parseInt(card.id),
                                                    user_id: parseInt(activity.attributes.user_id)
                                                });
                                                if (voted_user) {
                                                    var voter_id = parseInt(voted_user.id);
                                                    var card_voter = new App.CardVoter();
                                                    card_voter.set('id', voter_id);
                                                    card.card_voters.remove(card_voter);
                                                    if (!_.isUndefined(card.attributes.cards_voters) && card.attributes.cards_voters !== null) {
                                                        var card_voter_attr = card.attributes.cards_voters.filter(function(voter) {
                                                            return ((parseInt(voter.card_id) === parseInt(card.id)) && (parseInt(voter.user_id) === parseInt(activity.attributes.user_id)));
                                                        });
                                                        if (card_voter_attr.length > 0) {
                                                            var card_voter_attr_index = card.attributes.cards_voters.indexOf(card_voter_attr[0]);
                                                            card.attributes.cards_voters.splice(card_voter_attr_index, 1);
                                                        }
                                                    }
                                                    var card_voter_count = isNaN(card.attributes.card_voter_count) ? 0 : card.attributes.card_voter_count;
                                                    if (card_voter_count !== 0) {
                                                        card_voter_count = card_voter_count - 1;
                                                    }
                                                    card.set('card_voter_count', card_voter_count);
                                                }
                                            } else if (activity.attributes.type === 'delete_card') {
                                                self.board.cards.remove(card);
                                            }
                                        }
                                        if (!_.isUndefined(activity.attributes.card_id) && activity.attributes.card_id !== 0) {
                                            if (activity.attributes.type !== 'add_comment' && activity.attributes.type !== 'edit_comment' && activity.attributes.type !== 'delete_card_comment') {
                                                if ($('#js-card-modal-' + activity.attributes.card_id).length == 1) {
                                                    var modal_activity = activity;
                                                    modal_activity.attributes.comment = modal_activity.attributes.original_comment;
                                                    modal_activity.attributes = activityCommentReplace(modal_activity.attributes);
                                                    delete modal_activity.from_footer;
                                                    var new_activity_view = new App.ActivityView({
                                                        model: modal_activity,
                                                        board: self.board,
                                                        flag: '1'
                                                    });
                                                    if ($.cookie('filter') !== 'comment') {
                                                        var new_view_activity = $('#js-card-activities-' + activity.attributes.card_id);
                                                        if ($('#js-card-activities-' + activity.attributes.card_id + ' ' + '.js-list-activity-' + activity.attributes.id).length === 0) {
                                                            card.activities.unshift(modal_activity, {
                                                                silent: true
                                                            });
                                                            new_view_activity.prepend(new_activity_view.render().el);
                                                        }
                                                    }
                                                    emojify.run();
                                                }
                                            }
                                        }
                                    } else if (!_.isUndefined(activity.attributes.list_id) && activity.attributes.list_id !== 0 && !_.isUndefined(activity.attributes.board_id) && parseInt(activity.attributes.board_id) === parseInt(self.board_id)) { // Update List
                                        list = self.board.lists.findWhere({
                                            id: parseInt(activity.attributes.list_id)
                                        });
                                        if (activity.attributes.type === 'add_list') {
                                            var new_list = new App.List();
                                            new_list.set(activity.attributes.list);
                                            new_list.set('card_count', 0);
                                            new_list.set('id', parseInt(activity.attributes.list.id));
                                            new_list.set('board_id', parseInt(activity.attributes.list.board_id));
                                            new_list.set('lists_cards', []);
                                            new_list.set('is_archived', 0);
                                            new_list.set('position', parseFloat(activity.attributes.list.position));
                                            self.board.lists.add(new_list);
                                            if (self.board.attributes.lists === null) {
                                                self.board.attributes.lists = [];
                                            }
                                            if (self.board.attributes.lists !== null) {
                                                self.board.attributes.lists.push(new_list);
                                            }
                                            if (!_.isUndefined(App.boards) && !_.isUndefined(App.boards.get(new_list.attributes.board_id))) {
                                                App.boards.get(new_list.attributes.board_id).lists.add(new_list);
                                            }
                                        } else if (_.isUndefined(list) && activity.attributes.type === 'move_list' && !_.isUndefined(activity.attributes.list) && !_.isEmpty(activity.attributes.list) && activity.attributes.list !== null) {
                                            var new_move_list = new App.List();
                                            var activity_list = activity.attributes.list;
                                            board_id = parseInt(activity.attributes.board_id);
                                            var list_id = parseInt(activity.attributes.list_id);
                                            new_move_list.set(activity.attributes.list);
                                            new_move_list.set('card_count', 0);
                                            new_move_list.set('id', list_id);
                                            new_move_list.set('name', activity.attributes.list_name);
                                            new_move_list.set('board_id', board_id);
                                            new_move_list.set('lists_cards', []);
                                            new_move_list.set('is_archived', 0);
                                            new_move_list.set('position', parseFloat(activity_list.position));
                                            self.board.lists.add(new_move_list);
                                            if (self.board.attributes.lists === null || _.isUndefined(self.board.attributes.lists)) {
                                                self.board.attributes.lists = [];
                                            }
                                            if (self.board.attributes.lists !== null && !_.isUndefined(self.board.attributes.lists)) {
                                                self.board.attributes.lists.push(new_move_list);
                                            }
                                            if (!_.isUndefined(App.boards) && !_.isUndefined(App.boards.get(new_move_list.attributes.board_id))) {
                                                App.boards.get(new_move_list.attributes.board_id).lists.add(new_move_list);
                                            }
                                            $.ajax({
                                                url: api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards.json?token=' + authuser.access_token,
                                                cache: false,
                                                type: 'GET',
                                                success: function(response) {
                                                    if (!_.isUndefined(response.data) && response.data !== null && response.data.length > 0) {
                                                        _.each(response.data, function(card_data) {
                                                            if (parseInt(card_data.is_archived) === 0) {
                                                                var new_card = new App.Card();
                                                                var board_sort_by = (self.board.attributes.sort_by) ? self.board.attributes.sort_by : 'position';
                                                                var bard_sort_direction = (self.board.attributes.sort_direction) ? self.board.attributes.sort_direction : 'asc';
                                                                card_data.is_archived = parseInt(card_data.is_archived);
                                                                var card_checklist_item_count = isNaN(card_data.checklist_item_count) ? 0 : parseInt(card_data.checklist_item_count);
                                                                var card_checklist_item_completed_count = isNaN(card_data.checklist_item_completed_count) ? 0 : parseInt(card_data.checklist_item_completed_count);
                                                                var card_checklist_item_pending_count = card_checklist_item_count - card_checklist_item_completed_count;
                                                                new_card.set(card_data);
                                                                new_card.set('id', parseInt(card_data.id));
                                                                new_card.set('board_id', parseInt(card_data.board_id));
                                                                new_card.set('list_id', parseInt(card_data.list_id));
                                                                new_card.set('created', card_data.created);
                                                                new_card.set('modified', card_data.modified);
                                                                new_card.set('name', card_data.name);
                                                                new_card.set('description', card_data.description);
                                                                new_card.set('due_date', card_data.due_date);
                                                                new_card.set('is_archived', card_data.is_archived);
                                                                new_card.set('attachment_count', card_data.is_archived);
                                                                new_card.set('checklist_count', card_data.checklist_count);
                                                                new_card.set('checklist_item_count', card_checklist_item_count);
                                                                new_card.set('checklist_item_completed_count', card_checklist_item_completed_count);
                                                                new_card.set('checklist_item_pending_count', card_checklist_item_pending_count);
                                                                new_card.set('card_voter_count', parseInt(card_data.card_voter_count));
                                                                new_card.set('position', parseFloat(card_data.position));
                                                                new_card.set('user_id', parseInt(card_data.user_id));
                                                                new_card.set('is_archived', parseInt(card_data.is_archived));
                                                                var card_list = self.board.lists.findWhere({
                                                                    id: parseInt(list_id)
                                                                });
                                                                if (!_.isUndefined(card_list) && !_.isEmpty(card_list) && card_list !== null) {
                                                                    new_card.list = card_list;
                                                                    new_card.board = self.board;
                                                                    if (!_.isEmpty(card_list) && !_.isUndefined(card_list) && card_list !== null && !_.isEmpty(card_list.cards) && !_.isUndefined(card_list.cards) && card_list.cards !== null) {
                                                                        var tmp_list_cards = card_list.cards;
                                                                        tmp_list_cards.add(new_card, {
                                                                            silent: true
                                                                        });
                                                                        if (board_sort_by !== 'position') {
                                                                            var sort_filter_cards = self.cardsort(board_sort_by, bard_sort_direction, tmp_list_cards);
                                                                            $.each(sort_filter_cards.models, function(key, filter_card) {
                                                                                if (parseInt(filter_card.attributes.is_archived) === 0 && parseInt(filter_card.id) === parseInt(new_card.id)) {
                                                                                    new_card.set('position', key + 1);
                                                                                }
                                                                            });
                                                                        }
                                                                    }
                                                                }
                                                                if (!_.isEmpty(card_data.cards_users) && !_.isUndefined(card_data.cards_users) && card_data.cards_users !== null) {
                                                                    _.each(card_data.cards_users, function(user) {
                                                                        var new_card_user = new App.CardUser();
                                                                        new_card_user.set(user);
                                                                        new_card_user.set('id', parseInt(user.id));
                                                                        new_card_user.set('user_id', parseInt(user.user_id));
                                                                        new_card_user.set('card_id', parseInt(user.card_id));
                                                                        new_card_user.set('profile_picture_path', user.profile_picture_path);
                                                                        new_card_user.set('username', user.username);
                                                                        new_card_user.set('initials', user.initials);
                                                                        new_card_user.set('full_name', user.full_name);
                                                                        new_card.users.add(new_card_user, {
                                                                            silent: true
                                                                        });
                                                                        new_card.set('users', new_card_user, {
                                                                            silent: true
                                                                        });
                                                                    });
                                                                }
                                                                if (!_.isEmpty(card_data.cards_voters) && !_.isUndefined(card_data.cards_voters) && card_data.cards_voters !== null) {
                                                                    new_card.attributes.cards_voters = [];
                                                                    _.each(card_data.cards_voters, function(voter) {
                                                                        new_card.attributes.cards_voters.push(voter);
                                                                        var new_voter = new App.CardVoter();
                                                                        new_voter.set(voter);
                                                                        new_voter.set('id', parseInt(voter.id));
                                                                        new_voter.set('user_id', parseInt(voter.user_id));
                                                                        new_voter.set('card_id', parseInt(voter.card_id));
                                                                        new_card.card_voters.add(new_voter);
                                                                    });
                                                                }
                                                                if (!_.isEmpty(card_data.cards_labels) && !_.isUndefined(card_data.cards_labels) && card_data.cards_labels !== null) {
                                                                    _.each(card_data.cards_labels, function(label) {
                                                                        var new_card_label = new App.Label();
                                                                        new_card_label.set(label);
                                                                        new_card_label.set('id', parseInt(label.id));
                                                                        new_card_label.set('label_id', parseInt(label.label_id));
                                                                        new_card_label.set('card_id', parseInt(label.card_id));
                                                                        new_card_label.set('list_id', parseInt(label.list_id));
                                                                        new_card_label.set('board_id', parseInt(label.board_id));
                                                                        self.board.labels.add(new_card_label, {
                                                                            silent: true
                                                                        });
                                                                        var options = {
                                                                            silent: true
                                                                        };
                                                                        new_card.labels.add(new_card_label, options);
                                                                    });
                                                                    new_card.set('cards_labels', card_data.cards_labels);
                                                                }
                                                                if (!_.isEmpty(card_data.cards_checklists) && !_.isUndefined(card_data.cards_checklists) && card_data.cards_checklists !== null) {
                                                                    _.each(card_data.cards_checklists, function(checklist) {
                                                                        var new_card_checklist = new App.CheckList();
                                                                        new_card_checklist.set(checklist);
                                                                        new_card_checklist.set('id', parseInt(checklist.id));
                                                                        new_card_checklist.set('user_id', parseInt(checklist.user_id));
                                                                        new_card_checklist.set('card_id', parseInt(checklist.card_id));
                                                                        new_card_checklist.set('name', checklist.name);
                                                                        new_card_checklist.set('position', checklist.position);
                                                                        self.board.checklists.add(new_card_checklist, {
                                                                            silent: true
                                                                        });
                                                                        if (checklist.checklists_items !== null) {
                                                                            _.each(checklist.checklists_items, function(checklists_item) {
                                                                                var new_checklist_item = new App.CheckListItem();
                                                                                new_checklist_item.set(checklists_item);
                                                                                new_checklist_item.set('id', parseInt(checklists_item.id));
                                                                                new_checklist_item.set('user_id', parseInt(checklists_item.user_id));
                                                                                new_checklist_item.set('card_id', parseInt(checklists_item.card_id));
                                                                                new_checklist_item.set('checklist_id', parseInt(checklists_item.checklist_id));
                                                                                new_checklist_item.set('position', parseFloat(checklists_item.position));
                                                                                new_checklist_item.set('is_completed', checklists_item.is_completed);
                                                                                new_checklist_item.set('name', checklists_item.name);
                                                                                self.board.checklist_items.add(new_checklist_item, {
                                                                                    silent: true
                                                                                });
                                                                            });
                                                                            checklist_items = self.board.checklist_items.where({
                                                                                card_id: parseInt(checklist.card_id)
                                                                            });
                                                                            items = new App.CheckListItemCollection();
                                                                            items.add(checklist_items, {
                                                                                silent: true
                                                                            });
                                                                        }
                                                                    });
                                                                }
                                                                if (!_.isUndefined(card_list) && !_.isEmpty(card_list) && card_list !== null && !_.isUndefined(card_list.attributes.card_count) && card_list.attributes.card_count === 0) {
                                                                    // Removing the &nbsp; in the card listing after adding card or copy card
                                                                    $('#js-card-listing-' + card_list.id).find('.js-list-placeholder-' + card_list.id).remove();
                                                                }
                                                                if (!_.isUndefined(self.board) && !_.isEmpty(self.board) && self.board !== null && !_.isUndefined(self.board.cards) && !_.isEmpty(self.board.cards) && self.board.cards !== null) {
                                                                    self.board.cards.add(new_card);
                                                                }
                                                                if (!_.isUndefined(card_list) && !_.isEmpty(card_list) && card_list !== null && !_.isUndefined(card_list.cards) && !_.isEmpty(card_list.cards) && card_list.cards !== null) {
                                                                    card_list.cards.add(new_card);
                                                                    var card_list_card_count = isNaN(card_list.attributes.card_count) ? 0 : card_list.attributes.card_count;
                                                                    // Updating the list card count
                                                                    card_list.set('card_count', parseInt(card_list_card_count) + 1);
                                                                    if (card_list !== null && !_.isEmpty(card_list) && wip_enabled) {
                                                                        $('body').trigger('cardAddRendered', [card_list.id, card_list]);
                                                                    }
                                                                }
                                                                if ((!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null)) {
                                                                    $('body').trigger('CutomFieldsRendered', [parseInt(card_data.id), new_card]);
                                                                }
                                                            }
                                                        });
                                                    }
                                                    if (!_.isUndefined(response.attachments) && response.attachments !== null && response.attachments.length > 0) {
                                                        _.each(response.attachments, function(attachment) {
                                                            var new_card_attachment = new App.CardAttachment();
                                                            new_card_attachment.set(attachment);
                                                            new_card_attachment.set('id', parseInt(attachment.id));
                                                            new_card_attachment.set('board_id', parseInt(attachment.board_id));
                                                            new_card_attachment.set('list_id', parseInt(attachment.list_id));
                                                            new_card_attachment.set('card_id', parseInt(attachment.card_id));
                                                            if (!_.isUndefined(self.board) && !_.isEmpty(self.board) && self.board !== null && !_.isUndefined(self.board.cards) && !_.isEmpty(self.board.cards) && self.board.cards !== null) {
                                                                self.board.attachments.unshift(new_card_attachment);
                                                                var attachment_card = self.board.cards.findWhere({
                                                                    id: parseInt(attachment.card_id)
                                                                });
                                                                if (!_.isUndefined(attachment_card) && attachment_card !== null) {
                                                                    attachment_card.attachments.unshift(new_card_attachment);
                                                                }
                                                            }
                                                        });
                                                    }
                                                }
                                            });
                                        }
                                        if (!_.isUndefined(list)) {
                                            if (((!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) && (activity.attributes.type === 'add_list_agile_wip_limit' || activity.attributes.type === 'edit_list_agile_wip_limit' || activity.attributes.type === 'delete_list_agile_wip_limit' || activity.attributes.type === 'add_list_auto_archive_day' || activity.attributes.type === 'edit_list_auto_archive_day' || activity.attributes.type === 'delete_list_auto_archive_day' || activity.attributes.type === 'add_list_task_move_duedate' || activity.attributes.type === 'edit_list_task_move_duedate' || activity.attributes.type === 'delete_list_task_move_duedate')) && !_.isEmpty(activity.attributes.revisions.new_value.custom_fields)) {
                                                list.set('custom_fields', activity.attributes.revisions.new_value.custom_fields, {
                                                    silent: true
                                                });
                                                if (activity.attributes.type !== 'list_change_min' && activity.attributes.type !== 'list_change_max') {
                                                    $('body').trigger('listCutomFieldsRendered', [parseInt(activity.attributes.revisions.new_value.list_id), list]);
                                                }
                                            } else if (activity.attributes.revisions && activity.attributes.revisions.new_value && activity.attributes.type !== 'archived_card') {
                                                if (!_.isUndefined(activity.attributes.revisions) && !_.isEmpty(activity.attributes.revisions)) {
                                                    list.set(activity.attributes.revisions.new_value);

                                                }
                                            }
                                            if (activity.attributes.type === 'edit_list') {
                                                var edit_list_cards = self.board.cards.where({
                                                    list_id: parseInt(list.attributes.id),
                                                    is_archived: 0
                                                });
                                                if (!_.isUndefined(edit_list_cards) && !_.isEmpty(edit_list_cards) && edit_list_cards !== null) {
                                                    _.each(edit_list_cards, function(editcard) {
                                                        var options = {
                                                            silent: false
                                                        };
                                                        editcard.list_name = activity.attributes.revisions.new_value.name;
                                                        editcard.set('list_name', activity.attributes.revisions.new_value.name, options);
                                                    });
                                                }
                                            } else if (activity.attributes.type === 'delete_list') {
                                                removed_list_cards = self.board.cards.where({
                                                    list_id: parseInt(list.attributes.id)
                                                });
                                                self.board.cards.remove(removed_list_cards, {
                                                    silent: true
                                                });
                                                list.collection.board.lists.remove(list);
                                                self.board.lists.remove(list);
                                            } else if (activity.attributes.type === 'change_list_position') {
                                                if (parseInt(activity.attributes.list.board_id) !== parseInt(list.attributes.board_id)) {
                                                    self.board.lists.remove(list);
                                                } else {
                                                    list.set('position', parseFloat(activity.attributes.list.position));
                                                }
                                            } else if (activity.attributes.type === 'moved_list_card') {
                                                var cards = self.board.cards.where({
                                                    list_id: parseInt(activity.attributes.list_id)
                                                });
                                                var newList = self.board.lists.findWhere({
                                                    id: parseInt(activity.attributes.foreign_id)
                                                });
                                                var new_list_card_count = self.board.lists.get(activity.attributes.foreign_id).attributes.card_count;
                                                var previous_list_card_count = self.board.lists.get(list.id).attributes.card_count;
                                                new_list_card_count = new_list_card_count ? parseInt(new_list_card_count) : 0;
                                                previous_list_card_count = previous_list_card_count ? parseInt(previous_list_card_count) : 0;
                                                new_list_card_count = parseInt(new_list_card_count) + parseInt(previous_list_card_count);
                                                if (!_.isUndefined(cards) && cards.length > 0) {
                                                    // Removing the &nbsp; from the new list card listing
                                                    $('#js-card-listing-' + activity.attributes.foreign_id).find('.js-list-placeholder-' + activity.attributes.foreign_id).remove();
                                                    /* $('#js-card-listing-' + activity.attributes.foreign_id).html(function(i, h) {
                                                        return h.replace(/&nbsp;/g, '');
                                                    }); */
                                                    _.each(cards, function(card) {
                                                        var options = {
                                                            silent: false
                                                        };
                                                        self.board.cards.findWhere({
                                                            id: parseInt(card.attributes.id)
                                                        }).set({
                                                            list_id: parseInt(activity.attributes.foreign_id)
                                                        }, options);
                                                    });
                                                    newList.set('card_count', new_list_card_count);
                                                    list.set('card_count', 0);
                                                    if (!_.isUndefined(list) && !_.isUndefined(newList) && wip_enabled) {
                                                        $('body').trigger('listmoveActionRendered', [list.id, newList.id, new_list_card_count]);
                                                    }
                                                    // Adding the &nbsp; for the old list with no card
                                                    $('#js-card-listing-' + list.id).find('.js-list-placeholder-' + list.id).remove();
                                                    $('#js-card-listing-' + list.id).html('<span class="js-list-placeholder-' + list.id + '">&nbsp;</span>');
                                                    // $('#js-card-listing-' + list.id).html('&nbsp;');
                                                }
                                            } else if (activity.attributes.type === 'archived_card') {
                                                var list_cards = self.board.cards.where({
                                                    list_id: parseInt(activity.attributes.list_id)
                                                });
                                                if (!_.isUndefined(list_cards) && list_cards.length > 0) {
                                                    _.each(list_cards, function(card) {
                                                        self.board.cards.findWhere({
                                                            id: parseInt(card.attributes.id)
                                                        }).set({
                                                            is_archived: 1,
                                                            modified: activity.attributes.created
                                                        });
                                                    });
                                                    list.set('card_count', 0);
                                                    if (!_.isUndefined(list) && wip_enabled) {
                                                        $('body').trigger('cardAddRendered', [list.id, list]);
                                                    }
                                                    if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_gantt_view', APPS.enabled_apps) !== -1) {
                                                        $('body').trigger('GanttFilterRendered');
                                                    }
                                                    $('#js-card-listing-' + list.id).find('.js-list-placeholder-' + list.id).remove();
                                                    $('#js-card-listing-' + list.id).html('<span class="js-list-placeholder-' + list.id + '">&nbsp;</span>');
                                                }
                                            }
                                        }
                                    } else if (!_.isUndefined(self.board) && !_.isUndefined(activity.attributes.board_id) && !_.isUndefined(activity.attributes.board_id) && parseInt(activity.attributes.board_id) === parseInt(self.board_id)) { // Update Board
                                        if (!_.isUndefined(activity.attributes.revisions) && !_.isEmpty(activity.attributes.revisions)) {
                                            var board_fields;
                                            if (!_.isUndefined(activity.attributes.revisions.new_value) && !_.isEmpty(activity.attributes.revisions.new_value) && activity.attributes.revisions.new_value !== null) {
                                                board_fields = activity.attributes.revisions.new_value;
                                            } else {
                                                board_fields = JSON.parse(activity.attributes.revisions);
                                            }
                                            if (activity.attributes.type === 'update_sort_card') {
                                                window.sort_by = activity.attributes.revisions.new_value.sort_by;
                                                window.sort_direction = activity.attributes.revisions.new_value.sort_direction;
                                            }
                                            if (activity.attributes.type === 'change_background') {
                                                var oldImage = activity.attributes.revisions.old_value;
                                                var newImage = activity.attributes.revisions.new_value;
                                                _.each(newImage, function(field, key) {
                                                    if (oldImage[key] === newImage[key]) {
                                                        self.board.set(key, newImage[key], {
                                                            silent: true
                                                        });
                                                    } else {
                                                        self.board.set(key, newImage[key]);
                                                    }
                                                });
                                            } else {
                                                self.board.set(activity.attributes.revisions.new_value);
                                                if (activity.attributes.type === 'change_visibility') {
                                                    $('main').trigger('boardHeaderRendered');
                                                }
                                            }
                                            if (!_.isUndefined(board_fields.is_show_image_front_of_card)) {
                                                if (board_fields.is_show_image_front_of_card) {
                                                    $('div.js-card-attachment-image').removeClass('hide');
                                                } else {
                                                    $('div.js-card-attachment-image').addClass('hide');
                                                }
                                            }
                                        }
                                        if (activity.attributes.type === 'delete_archived_list') {
                                            var archived_lists = self.board.lists.where({
                                                is_archived: 1
                                            });
                                            if (archived_lists.length > 0) {
                                                _.each(archived_lists, function(list) {
                                                    removed_list_cards = self.board.cards.where({
                                                        list_id: parseInt(list.attributes.id)
                                                    });
                                                    self.board.cards.remove(removed_list_cards, {
                                                        silent: true
                                                    });
                                                    list.collection.board.lists.remove(list);
                                                    self.board.lists.remove(list, {
                                                        silent: true
                                                    });
                                                });
                                            }
                                            self.board.lists.each(function(list) {
                                                if (!_.isUndefined(list) && !_.isUndefined(list.attributes) && list.attributes.is_archived === 1) {
                                                    list.collection.remove(list);
                                                }
                                            });
                                        }
                                        if (activity.attributes.type === 'delete_archived_card') {
                                            var archived_cards = self.board.cards.where({
                                                is_archived: 1
                                            });
                                            if (archived_cards.length > 0) {
                                                _.each(archived_cards, function(card) {
                                                    self.board.cards.remove(card);
                                                });
                                                card_count = self.board.attributes.card_count - archived_cards.length;
                                                self.board.set('card_count', card_count);
                                            }
                                        }
                                        if (activity.attributes.type === 'add_board_user') {
                                            activity.attributes.board_user.board_id = parseInt(activity.attributes.board_user.board_id);
                                            activity.attributes.board_user.board_user_role_id = parseInt(activity.attributes.board_user.board_user_role_id);
                                            activity.attributes.board_user.default_email_list_id = parseInt(activity.attributes.board_user.default_email_list_id);
                                            activity.attributes.board_user.id = parseInt(activity.attributes.board_user.id);
                                            activity.attributes.board_user.user_id = parseInt(activity.attributes.board_user.user_id);
                                            if (!_.isUndefined(authuser.user) && !_.isEmpty(authuser.user) && authuser.user !== null) {
                                                if (parseInt(activity.attributes.board_user.user_id) === parseInt(authuser.user.id)) {
                                                    location.reload();
                                                }
                                            }
                                            self.board.board_users.add(activity.attributes.board_user);
                                        } else if (activity.attributes.type === 'delete_board_user') {
                                            var boarduser = self.board.board_users.findWhere({
                                                id: activity.attributes.foreign_id
                                            });
                                            var removedBoard = App.boards.get(parseInt(self.board_id));
                                            if (!_.isUndefined(authuser.user) && !_.isEmpty(authuser.user) && authuser.user !== null && parseInt(authuser.user.role_id) !== 1 && !_.isUndefined(removedBoard) && !_.isEmpty(removedBoard) && removedBoard !== null) {
                                                App.boards.remove(parseInt(self.board_id));
                                            }
                                            if (!_.isUndefined(boarduser) && !_.isEmpty(boarduser) && boarduser !== null) {
                                                self.board.board_users.remove(boarduser);
                                                if (parseInt(self.board.get('board_visibility')) === 2 && parseInt(boarduser.attributes.user_id) === parseInt(authuser.user.id)) {
                                                    location.reload();
                                                } else if (parseInt(boarduser.attributes.user_id) === parseInt(authuser.user.id)) {
                                                    app.navigate('#/boards', {
                                                        trigger: true,
                                                        replace: true
                                                    });
                                                }
                                            }
                                        } else if (activity.attributes.type === 'delete_label') {
                                            var label_value = JSON.parse(activity.attributes.revisions);
                                            var filter_labels = self.board.labels.filter(function(model) {
                                                return parseInt(model.get('label_id')) === parseInt(label_value.id);
                                            });
                                            var deleteLabelcards = self.board.cards.filter(function(card) {
                                                return card.get('is_archived') !== 1 && !_.isUndefined(card.labels) && card.labels.length > 0 && !_.isEmpty(card.labels.findWhere({
                                                    label_id: parseInt(label_value.id)
                                                }));
                                            });
                                            if (!_.isUndefined(deleteLabelcards) && !_.isEmpty(deleteLabelcards) && deleteLabelcards !== null) {
                                                _.each(deleteLabelcards, function(card) {
                                                    var label = card.labels.filter(function(model) {
                                                        return parseInt(model.get('label_id')) === parseInt(label_value.id);
                                                    });
                                                    card.labels.remove(label, {
                                                        silent: false
                                                    });
                                                    if (!_.isUndefined(card.attributes.cards_labels) && !_.isEmpty(card.attributes.cards_labels) && card.attributes.cards_labels !== null && card.attributes.cards_labels.length > 0) {
                                                        var card_attr_labels = card.attributes.cards_labels.filter(function(label) {
                                                            return parseInt(label.label_id) === parseInt(label_value.id);
                                                        });
                                                        if (card_attr_labels.length > 0) {
                                                            var card_attr_labels_index = card.attributes.cards_labels.indexOf(card_attr_labels[0]);
                                                            card.attributes.cards_labels.splice(card_attr_labels_index, 1);
                                                        }
                                                    }
                                                });
                                            }
                                            self.board.labels.remove(filter_labels, {
                                                silent: false
                                            });
                                        } else if (activity.attributes.type === 'update_label') {
                                            var update_label_value = JSON.parse(activity.attributes.revisions);
                                            var board_labels = activity.attributes.labels;
                                            var card_filter_labels = self.board.labels.filter(function(model) {
                                                return parseInt(model.get('label_id')) === parseInt(update_label_value.id);
                                            });
                                            self.board.labels.remove(card_filter_labels, {
                                                silent: true
                                            });
                                            _.each(board_labels, function(label) {
                                                card = self.board.cards.findWhere({
                                                    id: parseInt(label.card_id)
                                                });
                                                card.labels.remove(card_filter_labels, {
                                                    silent: true
                                                });
                                                var card_label = new App.Label();
                                                card_label.set(label);
                                                card_label.set('id', parseInt(label.id));
                                                card_label.set('name', label.name);
                                                card_label.set('color', label.color);
                                                card_label.set('label_id', parseInt(label.label_id));
                                                card_label.set('card_id', parseInt(label.card_id));
                                                card_label.set('list_id', parseInt(label.list_id));
                                                card_label.set('board_id', parseInt(label.board_id));
                                                self.board.labels.add(card_label, {
                                                    silent: true
                                                });
                                                var options = {
                                                    silent: false
                                                };
                                                card.labels.add(card_label, options);
                                                card.set('cards_labels', null, {
                                                    silent: true
                                                });
                                                card.set('cards_labels', card.labels);
                                            });
                                        } else if (activity.attributes.type == 'change_grid_view_configuration' || activity.attributes.type == 'change_list_view_configuration') {
                                            var board_custom_fields = JSON.parse(activity.attributes.revisions);
                                            if ((!_.isUndefined(board_custom_fields) && !_.isEmpty(board_custom_fields) && board_custom_fields !== null) && (!_.isUndefined(board_custom_fields.r_gridview_configure) || !_.isUndefined(board_custom_fields.r_listview_configure))) {
                                                self.board.set('board_custom_fields', activity.attributes.revisions);
                                            }
                                        } else if (activity.attributes.type === 'close_board') {
                                            if (!_.isUndefined(App.boards.get(activity.attributes.board_id)) && !_.isEmpty(App.boards.get(activity.attributes.board_id)) && App.boards.get(activity.attributes.board_id) !== null) {
                                                App.boards.get(activity.attributes.board_id).set('is_closed', 1);
                                            }
                                            self.board.set('is_closed', 1);
                                        } else if (activity.attributes.type === 'reopen_board') {
                                            App.boards.get(activity.attributes.board_id).set('is_closed', 0);
                                            self.board.set('is_closed', 0);
                                        }
                                    } else if (!_.isUndefined(activity.attributes.list_id) && activity.attributes.list_id !== 0 && !_.isUndefined(activity.attributes.board_id) && activity.attributes.type === 'move_list') {
                                        if (activity.attributes.revisions && activity.attributes.revisions.old_value) {
                                            board_id = activity.attributes.revisions.old_value.board_id;
                                            if (parseInt(board_id) === parseInt(self.board_id)) {
                                                list = self.board.lists.findWhere({
                                                    id: parseInt(activity.attributes.list_id)
                                                });
                                                removed_list_cards = self.board.cards.where({
                                                    list_id: parseInt(list.attributes.id)
                                                });
                                                self.board.cards.remove(removed_list_cards, {
                                                    silent: true
                                                });
                                                list.collection.board.lists.remove(list);
                                                self.board.lists.remove(list);
                                            }
                                        }
                                    } else if (!_.isUndefined(activity.attributes.card_id) && activity.attributes.card_id !== 0 && !_.isUndefined(activity.attributes.board_id) && activity.attributes.type === 'move_card') {
                                        if (activity.attributes.revisions && activity.attributes.revisions.old_value) {
                                            board_id = activity.attributes.revisions.old_value.board_id;
                                            if (parseInt(board_id) === parseInt(self.board_id) && activity.attributes.card_id) {
                                                card = self.board.cards.findWhere({
                                                    id: parseInt(activity.attributes.card_id)
                                                });

                                                card.set("is_archived", 1, {
                                                    silent: true
                                                });
                                                self.board.cards.remove(card, {
                                                    silent: false
                                                });
                                            }
                                        }
                                    }
                                }
                            }
                            if (activity.attributes.token !== authuser.access_token) {
                                if (!_.isUndefined(self.boards)) {
                                    var board = '';
                                    var board_list = '';
                                    var organization_boards = '';
                                    if (activity.attributes.board_id) {
                                        board = self.boards.findWhere({
                                            id: parseInt(activity.attributes.board_id)
                                        });
                                    }
                                    if (!_.isUndefined(board)) {
                                        if (activity.attributes.list_id) {
                                            board_list = board.lists.findWhere({
                                                id: parseInt(activity.attributes.list_id)
                                            });
                                        }
                                        if (activity.attributes.type === 'edit_organization' || activity.attributes.type === 'add_organization_attachment' || activity.attributes.type === 'delete_organization_attachment') {
                                            organization_boards = self.boards.findWhere({
                                                organization_id: parseInt(activity.attributes.organization_id)
                                            });
                                        }
                                        if (activity.attributes.type == 'edit_board') {
                                            board.set('name', activity.attributes.revisions.new_value.name);
                                        } else if (activity.attributes.type == 'change_visibility') {
                                            board.set('board_visibility', activity.attributes.revisions.new_value.board_visibility);
                                        } else if (activity.attributes.type == 'change_background') {
                                            board.set('background_color', activity.attributes.revisions.new_value.background_color);
                                            board.set('background_picture_url', activity.attributes.revisions.new_value.background_picture_url);
                                            board.set('background_pattern_url', activity.attributes.revisions.new_value.background_pattern_url);
                                        } else if (activity.attributes.type === 'add_card' || activity.attributes.type === 'copy_card') {
                                            if (!_.isUndefined(authuser) && !_.isUndefined(authuser.user) && parseInt(activity.attributes.user_id) === parseInt(authuser.user.id) && activity.attributes.type === 'add_card') {
                                                // While using instant add card, count duplicates for logged in user. So skipped the card count update while fetch activities.
                                            } else {
                                                card_count = board.attributes.card_count + 1;
                                                board.set('card_count', card_count);
                                                board_list.set('card_count', board_list.attributes.card_count + 1);
                                            }
                                        } else if (activity.attributes.type === 'delete_card') {
                                            card_count = board.attributes.card_count - 1;
                                            board.set('card_count', card_count);
                                            board_list.set('card_count', board_list.attributes.card_count - 1);
                                        } else if (activity.attributes.type === 'move_card' || activity.attributes.type === 'moved_list_card') {
                                            if (!_.isEmpty(activity.attributes.revisions.new_value)) {
                                                board.set('card_count', '');
                                                card_count = board.attributes.card_count;
                                                board.set('card_count', card_count);
                                                var new_board_list = board.lists.findWhere({
                                                    id: parseInt(activity.attributes.revisions.new_value.list_id)
                                                });
                                                new_board_list.set('card_count', new_board_list.attributes.card_count + 1);
                                                var old_board_list = board.lists.findWhere({
                                                    id: parseInt(activity.attributes.revisions.old_value.list_id)
                                                });
                                                old_board_list.set('card_count', old_board_list.attributes.card_count - 1);
                                            }
                                        } else if (activity.attributes.type === 'change_list_position') {
                                            if (!_.isEmpty(activity.attributes.revisions.new_value)) {
                                                var change_new_list = board.lists.findWhere({
                                                    id: parseInt(activity.attributes.revisions.new_value.board_id)
                                                });
                                                change_new_list.add(activity.attributes.list);
                                                var new_board = self.boards.findWhere({
                                                    id: parseInt(activity.attributes.revisions.new_value.board_id)
                                                });
                                                new_board.set('card_count', change_new_list.attributes.card_count + 1);
                                                var change_old_list = board.lists.findWhere({
                                                    id: parseInt(activity.attributes.revisions.old_value.board_id)
                                                });
                                                change_old_list.remove(activity.attributes.list);
                                                var old_board = self.boards.findWhere({
                                                    id: parseInt(activity.attributes.revisions.old_value.board_id)
                                                });
                                                old_board.set('card_count', change_old_list.attributes.card_count - 1);
                                            }
                                        } else if (activity.attributes.type === 'edit_list') {
                                            board_list.set('name', activity.attributes.revisions.new_value.name);
                                        } else if (activity.attributes.type === 'delete_list') {
                                            card_count = board.attributes.card_count;
                                            board.set('card_count', card_count - board_list.attributes.card_count);
                                            board_list.remove(board.attributes.list);
                                        } else if (activity.attributes.type === 'edit_organization') {
                                            _.each(organization_boards.collection.models, function(organization_board) {
                                                var rename_organization_board = self.boards.findWhere({
                                                    id: parseInt(organization_board.id)
                                                });
                                                rename_organization_board.set('organization_name', activity.attributes.revisions.new_value.name);
                                            });
                                        } else if (activity.attributes.type === 'add_organization_attachment' || activity.attributes.type === 'delete_organization_attachment') {
                                            _.each(organization_boards.collection.models, function(organization_board) {
                                                var change_organization_board = self.boards.findWhere({
                                                    id: parseInt(organization_board.id)
                                                });
                                                change_organization_board.set('organization_logo_url', activity.attributes.organization_logo_url);
                                            });
                                        } else if (activity.attributes.type === 'add_board_user') {
                                            activity.attributes.board_user.board_id = parseInt(activity.attributes.board_user.board_id);
                                            activity.attributes.board_user.board_user_role_id = parseInt(activity.attributes.board_user.board_user_role_id);
                                            activity.attributes.board_user.default_email_list_id = parseInt(activity.attributes.board_user.default_email_list_id);
                                            activity.attributes.board_user.id = parseInt(activity.attributes.board_user.id);
                                            activity.attributes.board_user.user_id = parseInt(activity.attributes.board_user.user_id);
                                            board.board_users.add(activity.attributes.board_user);
                                        }
                                    }
                                } else if (!_.isUndefined(App.boards) && !_.isEmpty(App.boards) && App.boards !== null && mode == 1) {
                                    if (activity.attributes.type === 'add_board') {
                                        var _new_board = new App.Board();
                                        _new_board.set('id', parseInt(activity.attributes.board_id));
                                        _new_board.set('name', filterXSS(activity.attributes.board_name));
                                        _new_board.set('is_closed', 0);
                                        if (!_.isUndefined(activity.attributes.board) && !_.isEmpty(activity.attributes.board) && activity.attributes.board !== null) {
                                            var tmp_new_board = activity.attributes.board;
                                            _new_board.set('organization_id', parseInt(tmp_new_board.organization_id));
                                            _new_board.set('board_visibility', parseInt(tmp_new_board.board_visibility));
                                            if (!_.isUndefined(tmp_new_board.organization_name) && !_.isEmpty(tmp_new_board.organization_name) && tmp_new_board.organization_name !== null) {
                                                _new_board.set('organization_name', tmp_new_board.organization_name);
                                            }
                                            if (!_.isUndefined(tmp_new_board.background_pattern_url) && !_.isEmpty(tmp_new_board.background_pattern_url) && tmp_new_board.background_pattern_url !== null) {
                                                _new_board.set('background_pattern_url', tmp_new_board.background_pattern_url);
                                            }
                                            if (!_.isUndefined(tmp_new_board.background_picture_url) && !_.isEmpty(tmp_new_board.background_picture_url) && tmp_new_board.background_picture_url !== null) {
                                                _new_board.set('background_picture_url', tmp_new_board.background_picture_url);
                                            }
                                            if (!_.isUndefined(tmp_new_board.music_content) && !_.isEmpty(tmp_new_board.music_content) && tmp_new_board.music_content !== null) {
                                                _new_board.set('music_content', tmp_new_board.music_content);
                                            }
                                            if (!_.isUndefined(tmp_new_board.music_name) && !_.isEmpty(tmp_new_board.music_name) && tmp_new_board.music_name !== null) {
                                                _new_board.set('music_name', tmp_new_board.music_name);
                                            }
                                        }
                                        if (!_.isUndefined(activity.attributes.lists) && !_.isEmpty(activity.attributes.lists) && activity.attributes.lists !== null) {
                                            var _tmp_list_collection = activity.attributes.lists;
                                            var _new_board_lists = new App.ListCollection();
                                            _new_board_lists.board = _new_board;
                                            _.each(_tmp_list_collection, function(list) {
                                                var _tmp_list = new App.List();
                                                _tmp_list.set('id', parseInt(list.id));
                                                _tmp_list.set('name', filterXSS(list.name));
                                                _tmp_list.set('uuid', new Date().getTime());
                                                _tmp_list.set('is_archived', 0);
                                                _tmp_list.set('position', parseInt(list.position));
                                                _tmp_list.set('board_id', parseInt(_new_board.attributes.id));
                                                _new_board_lists.add(_tmp_list);
                                                _new_board.lists.add(_tmp_list);
                                            });
                                        }
                                        $('#boards-index').find('.js-my-boards').prepend(new App.BoardSimpleView({
                                            model: _new_board,
                                            id: 'js-my-board-' + activity.attributes.board_id,
                                            className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad js-board-view js-board-view-' + activity.attributes.board_id
                                        }).el);
                                        App.boards.add(_new_board);
                                    } else if (activity.attributes.type === 'change_visibility') {
                                        var existing_board;
                                        if (activity.attributes.board_id) {
                                            existing_board = App.boards.findWhere({
                                                id: parseInt(activity.attributes.board_id)
                                            });
                                        }
                                        if (!_.isUndefined(existing_board) && !_.isEmpty(existing_board) && existing_board !== null) {
                                            existing_board.set('board_visibility', activity.attributes.revisions.new_value.board_visibility);
                                        }
                                    } else if (activity.attributes.type === 'close_board') {
                                        if (!_.isUndefined(App.boards.get(parseInt(activity.attributes.board_id))) && !_.isEmpty(App.boards.get(parseInt(activity.attributes.board_id))) && App.boards.get(parseInt(activity.attributes.board_id)) !== null) {
                                            App.boards.get(parseInt(activity.attributes.board_id)).set('is_closed', 1);
                                        }
                                    } else if (activity.attributes.type === 'edit_board') {
                                        var edit_board = App.boards.get(parseInt(activity.attributes.board_id));
                                        if (!_.isUndefined(edit_board) && !_.isEmpty(edit_board) && edit_board !== null) {
                                            edit_board.set('name', activity.attributes.revisions.new_value.name);
                                        }
                                    } else if (activity.attributes.type === 'reopen_board') {
                                        App.boards.get(parseInt(activity.attributes.board_id)).set('is_closed', 0);
                                    } else if (activity.attributes.type === 'update_sort_card') {
                                        if (!_.isUndefined(activity.attributes.revisions) && !_.isEmpty(activity.attributes.revisions) && !_.isUndefined(App.boards.get(parseInt(activity.attributes.board_id))) && App.boards.get(parseInt(activity.attributes.board_id)) !== null) {
                                            App.boards.get(parseInt(activity.attributes.board_id)).set(activity.attributes.revisions.new_value);
                                        }
                                    } else if (activity.attributes.type === 'delete_board_user') {
                                        if ($('#js-my-board-' + activity.attributes.board_id).length > 0) {
                                            $('#js-my-board-' + activity.attributes.board_id).remove();
                                        }
                                    } else if (activity.attributes.type === 'add_list') {
                                        var board_new_list = new App.List();
                                        board_new_list.set(activity.attributes.list);
                                        board_new_list.set('card_count', 0);
                                        board_new_list.set('id', parseInt(activity.attributes.list.id));
                                        board_new_list.set('board_id', parseInt(activity.attributes.list.board_id));
                                        board_new_list.set('lists_cards', []);
                                        board_new_list.set('is_archived', 0);
                                        board_new_list.set('is_deleted', 0);
                                        board_new_list.set('position', parseFloat(activity.attributes.list.position));
                                        if (!_.isUndefined(App.boards) && !_.isUndefined(App.boards.get(board_new_list.attributes.board_id))) {
                                            var is_list_exist = App.boards.get(parseInt(board_new_list.attributes.board_id)).lists.get(parseInt(activity.attributes.list.id));
                                            if (_.isUndefined(is_list_exist) || _.isEmpty(is_list_exist) || is_list_exist === null) {
                                                if (App.boards.get(parseInt(board_new_list.attributes.board_id)).attributes.lists === null || _.isUndefined(App.boards.get(parseInt(board_new_list.attributes.board_id)).attributes.lists)) {
                                                    App.boards.get(parseInt(board_new_list.attributes.board_id)).attributes.lists = [];
                                                }
                                                if (App.boards.get(parseInt(board_new_list.attributes.board_id)).attributes.lists !== null && !_.isUndefined(App.boards.get(parseInt(board_new_list.attributes.board_id)).attributes.lists)) {
                                                    App.boards.get(parseInt(board_new_list.attributes.board_id)).lists.add(board_new_list);
                                                    App.boards.get(parseInt(board_new_list.attributes.board_id)).attributes.lists.push(board_new_list);
                                                }
                                            }
                                        }
                                    } else if (activity.attributes.type === 'edit_list') {
                                        var currrnt_board = App.boards.get(parseInt(activity.attributes.board_id));
                                        if (!_.isUndefined(currrnt_board) && !_.isEmpty(currrnt_board) && currrnt_board !== null) {
                                            var boardList = currrnt_board.lists.get(parseInt(activity.attributes.list_id));
                                            if (!_.isUndefined(boardList) && !_.isEmpty(boardList) && boardList !== null) {
                                                boardList.set('name', activity.attributes.revisions.new_value.name, {
                                                    silent: true
                                                });
                                            }
                                        }
                                    } else if (activity.attributes.type === 'move_list') {
                                        var old_list_board_id = parseInt(activity.attributes.revisions.old_value.board_id);
                                        var lists_id = parseInt(activity.attributes.list.id);
                                        var old_list_position = parseFloat(activity.attributes.revisions.old_value.position);
                                        var OldBoard = App.boards.get(old_list_board_id);
                                        if (!_.isUndefined(OldBoard) && OldBoard !== null && !_.isEmpty(OldBoard)) {
                                            var old_board_list_details = App.boards.get(old_list_board_id).lists.get(lists_id);
                                            if (!_.isUndefined(old_board_list_details) && old_board_list_details !== null && !_.isEmpty(old_board_list_details) && !_.isUndefined(activity.attributes.list) && activity.attributes.list !== null && !_.isEmpty(activity.attributes.list)) {
                                                var oldBoardlist = new App.List();
                                                oldBoardlist.set(old_board_list_details.attributes);
                                                oldBoardlist.set('is_archived', parseInt(old_board_list_details.attributes.is_archived));
                                                oldBoardlist.set('board_id', old_list_board_id);
                                                oldBoardlist.set('position', old_list_position);
                                                oldBoardlist.set('id', parseInt(activity.attributes.list.id));
                                                oldBoardlist.set('name', activity.attributes.list.name);
                                                oldBoardlist.set('card_count', activity.attributes.list.card_count);
                                                oldBoardlist.set('lists_cards', []);
                                                App.boards.get(old_list_board_id).lists.remove(oldBoardlist);
                                            }
                                            if (App.boards.get(old_list_board_id).attributes && !_.isUndefined(App.boards.get(old_list_board_id).attributes.lists) && App.boards.get(old_list_board_id).attributes.lists !== null) {
                                                if (App.boards.get(old_list_board_id).attributes.lists.length > 0) {
                                                    var boards_attr_list = App.boards.get(old_list_board_id).attributes.lists.filter(function(list) {
                                                        return parseInt(list.id) === parseInt(activity.attributes.list.id);
                                                    });
                                                    if (boards_attr_list.length > 0) {
                                                        var boards_attr_list_index = App.boards.get(old_list_board_id).attributes.lists.indexOf(boards_attr_list[0]);
                                                        App.boards.get(old_list_board_id).attributes.lists.splice(boards_attr_list_index, 1);
                                                    }
                                                }
                                            }
                                        }
                                        var newBoardlist = new App.List();
                                        newBoardlist.set(activity.attributes.list);
                                        newBoardlist.set('card_count', parseInt(activity.attributes.list.card_count));
                                        newBoardlist.set('id', parseInt(activity.attributes.list.id));
                                        newBoardlist.set('board_id', parseInt(activity.attributes.list.board_id));
                                        newBoardlist.set('lists_cards', []);
                                        newBoardlist.set('is_archived', 0);
                                        newBoardlist.set('is_deleted', 0);
                                        newBoardlist.set('position', parseFloat(activity.attributes.list.position));
                                        if (!_.isUndefined(App.boards) && !_.isEmpty(App.boards) & App.boards !== null) {
                                            if (!_.isUndefined(App.boards.get(old_list_board_id)) && !_.isUndefined(App.boards.get(newBoardlist.attributes.board_id))) {
                                                var moveListCards = App.boards.get(old_list_board_id).cards.where({
                                                    'list_id': lists_id
                                                });
                                                _.each(moveListCards, function(card) {
                                                    var moveListCard = App.boards.get(old_list_board_id).cards.get(parseInt(card.id));
                                                    moveListCard.attributes.list_id = newBoardlist.attributes.id;
                                                    moveListCard.attributes.board_id = newBoardlist.attributes.board_id;
                                                    App.boards.get(newBoardlist.attributes.board_id).cards.add(moveListCard);
                                                    moveListCard.collection = App.boards.get(newBoardlist.attributes.board_id).cards;
                                                    App.boards.get(old_list_board_id).cards.remove(parseInt(card.id));
                                                });
                                            }

                                            if (!_.isUndefined(App.boards.get(newBoardlist.attributes.board_id))) {
                                                var list_already_exist = App.boards.get(parseInt(newBoardlist.attributes.board_id)).lists.get(parseInt(activity.attributes.list.id));
                                                if (_.isUndefined(list_already_exist) || _.isEmpty(list_already_exist) || list_already_exist === null) {
                                                    if (App.boards.get(parseInt(newBoardlist.attributes.board_id)).attributes.lists === null || _.isUndefined(App.boards.get(parseInt(newBoardlist.attributes.board_id)).attributes.lists)) {
                                                        App.boards.get(parseInt(newBoardlist.attributes.board_id)).attributes.lists = [];
                                                    }
                                                    App.boards.get(parseInt(newBoardlist.attributes.board_id)).lists.add(newBoardlist);
                                                    if (App.boards.get(parseInt(newBoardlist.attributes.board_id)).attributes.lists !== null && !_.isUndefined(App.boards.get(parseInt(newBoardlist.attributes.board_id)).attributes.lists)) {
                                                        App.boards.get(parseInt(newBoardlist.attributes.board_id)).attributes.lists.push(newBoardlist);
                                                    }
                                                }
                                            }
                                        }
                                    } else if (activity.attributes.type === 'archive_list' || activity.attributes.type === 'unarchive_list') {
                                        if (!_.isUndefined(activity.attributes.revisions) && !_.isEmpty(activity.attributes.revisions)) {
                                            var list_board_id = parseInt(activity.attributes.board_id);
                                            if (!_.isUndefined(App.boards.get(list_board_id)) && !_.isEmpty(App.boards.get(list_board_id)) && App.boards.get(list_board_id) !== null && !_.isUndefined(App.boards.get(list_board_id).lists.get(parseInt(activity.attributes.list_id))) && !_.isEmpty(App.boards.get(list_board_id).lists.get(parseInt(activity.attributes.list_id))) && App.boards.get(list_board_id).lists.get(parseInt(activity.attributes.list_id)) !== null) {
                                                if (activity.attributes.type === 'archive_list') {
                                                    App.boards.get(list_board_id).lists.get(parseInt(activity.attributes.list_id)).set('is_archived', 1);
                                                } else {
                                                    App.boards.get(list_board_id).lists.get(parseInt(activity.attributes.list_id)).set('is_archived', 0);
                                                }
                                            }
                                            if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_gantt_view', APPS.enabled_apps) !== -1) {
                                                $('body').trigger('GanttFilterRendered');
                                            }
                                            if (App.boards.get(list_board_id).attributes && !_.isUndefined(App.boards.get(list_board_id).attributes.lists) && App.boards.get(list_board_id).attributes.lists !== null) {
                                                if (App.boards.get(list_board_id).attributes.lists.length > 0) {
                                                    var boards_list_attr = App.boards.get(list_board_id).attributes.lists.filter(function(list) {
                                                        return parseInt(list.id) === parseInt(activity.attributes.list_id);
                                                    });
                                                    if (boards_list_attr.length > 0) {
                                                        var boards_list_attr_index = App.boards.get(list_board_id).attributes.lists.indexOf(boards_list_attr[0]);
                                                        if (activity.attributes.type === 'archive_list') {
                                                            App.boards.get(list_board_id).attributes.lists[boards_list_attr_index].is_archived = 1;
                                                        } else {
                                                            App.boards.get(list_board_id).attributes.lists[boards_list_attr_index].is_archived = 0;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } else if (activity.attributes.type === 'delete_list') {
                                        var delete_list_id = parseInt(activity.attributes.list_id);
                                        var delete_board_id = parseInt(activity.attributes.board_id);
                                        var board_delete_list = App.boards.get(delete_board_id).lists.get(delete_list_id);
                                        var delete_list = new App.List();
                                        if (!_.isUndefined(board_delete_list) && !_.isEmpty(board_delete_list) && board_delete_list !== null) {
                                            delete_list.set(board_delete_list.attributes);
                                            delete_list.set('card_count', parseInt(board_delete_list.attributes.card_count));
                                            delete_list.set('id', delete_list_id);
                                            delete_list.set('board_id', delete_board_id);
                                            delete_list.set('lists_cards', []);
                                            delete_list.set('is_archived', parseInt(board_delete_list.attributes.is_archived));
                                            App.boards.get(delete_board_id).lists.remove(delete_list);
                                            if (App.boards.get(delete_board_id).attributes && !_.isUndefined(App.boards.get(delete_board_id).attributes.lists) && App.boards.get(delete_board_id).attributes.lists !== null) {
                                                if (App.boards.get(delete_board_id).attributes.lists.length > 0) {
                                                    var board_attr_list = App.boards.get(delete_board_id).attributes.lists.filter(function(list) {
                                                        return parseInt(list.id) === delete_list_id;
                                                    });
                                                    if (board_attr_list.length > 0) {
                                                        var board_attr_list_index = App.boards.get(delete_board_id).attributes.lists.indexOf(board_attr_list[0]);
                                                        App.boards.get(delete_board_id).attributes.lists.splice(board_attr_list_index, 1);
                                                    }
                                                }
                                            }
                                        }
                                    } else if (activity.attributes.type === 'add_card' || activity.attributes.type === 'copy_card') {
                                        var board_new_card = new App.Card();
                                        board_new_card.set(activity.attributes.card);
                                        var new_card_voter = isNaN(activity.attributes.card.card_voter_count) ? 0 : activity.attributes.card.card_voter_count;
                                        new_card_voter = parseInt(new_card_voter);
                                        var new_card_checklist_count = isNaN(activity.attributes.card.checklist_item_count) ? 0 : activity.attributes.card.checklist_item_count;
                                        new_card_checklist_count = parseInt(new_card_checklist_count);
                                        var new_card_attachment = isNaN(activity.attributes.card.attachment_count) ? 0 : activity.attributes.card.attachment_count;
                                        new_card_attachment = parseInt(new_card_attachment);
                                        board_new_card.set('id', parseInt(activity.attributes.card.id));
                                        board_new_card.set('board_id', parseInt(activity.attributes.card.board_id));
                                        board_new_card.set('list_id', parseInt(activity.attributes.card.list_id));
                                        board_new_card.set('list_name', parseInt(activity.attributes.card.list_name), {
                                            silent: true
                                        });
                                        board_new_card.set('is_archived', 0);
                                        board_new_card.set('position', parseFloat(activity.attributes.card.position));
                                        board_new_card.set('comment_count', 0);
                                        board_new_card.set('card_voter_count', new_card_voter);
                                        board_new_card.set('checklist_item_count', new_card_checklist_count);
                                        board_new_card.set('checklist_item_completed_count', 0);
                                        board_new_card.set('checklist_item_pending_count', new_card_checklist_count);
                                        board_new_card.set('attachment_count', new_card_attachment);
                                        board_new_card.set('created', activity.attributes.card.created);
                                        board_new_card.set('modified', activity.attributes.card.created);
                                        if (!_.isUndefined(activity.attributes.card.due_date) && activity.attributes.card.due_date !== null) {
                                            board_new_card.set('created', activity.attributes.card.created);
                                        }
                                        if (!_.isUndefined(App.boards) && !_.isUndefined(App.boards.get(board_new_card.attributes.board_id))) {
                                            var is_card_exist = App.boards.get(parseInt(board_new_card.attributes.board_id)).cards.get(parseInt(activity.attributes.card.id));
                                            if (_.isUndefined(is_card_exist) || _.isEmpty(is_card_exist) || is_card_exist === null) {
                                                App.boards.get(parseInt(board_new_card.attributes.board_id)).cards.add(board_new_card);
                                            }
                                        }
                                    } else if (activity.attributes.type === 'move_card') {
                                        var card_revision = activity.attributes.revisions;
                                        var cardDetails = activity.attributes.card;
                                        var old_card_list = parseInt(activity.attributes.revisions.old_value.list_id);
                                        var new_card_list = parseInt(activity.attributes.revisions.new_value.list_id);
                                        var new_card_position = parseFloat(activity.attributes.revisions.new_value.position);
                                        var moved_card, oldList, newCardList, oldListCardCount, newListCardCount;
                                        if (!_.isUndefined(card_revision.new_value.board_id) && card_revision.new_value.board_id !== null && parseInt(card_revision.new_value.board_id) !== parseInt(card_revision.old_value.board_id)) {
                                            var old_card_board_id = parseInt(activity.attributes.revisions.old_value.board_id);
                                            var new_card_board_id = parseInt(activity.attributes.revisions.new_value.board_id);
                                            if (!_.isUndefined(App.boards) && !_.isEmpty(App.boards) & App.boards !== null && !_.isUndefined(App.boards.get(old_card_board_id))) {
                                                var old_board_card_details = App.boards.get(old_card_board_id).cards.get(cardDetails.id);
                                                if (!_.isUndefined(old_board_card_details) && !_.isEmpty(old_board_card_details) && old_board_card_details !== null) {
                                                    var oldBoardCard = new App.Card();
                                                    oldBoardCard.set(old_board_card_details.attributes);
                                                    oldBoardCard.set('id', parseInt(cardDetails.id));
                                                    oldBoardCard.set('name', cardDetails.name);
                                                    oldBoardCard.set('board_id', old_card_board_id);
                                                    oldBoardCard.set('list_id', old_card_list);
                                                    oldBoardCard.set('is_archived', parseInt(old_board_card_details.attributes.is_archived));
                                                    oldBoardCard.set('position', old_board_card_details.attributes.position);
                                                    App.boards.get(old_card_board_id).lists.remove(oldBoardCard);
                                                }
                                                oldList = App.boards.get(old_card_board_id).lists.get(old_card_list);
                                                if (!_.isUndefined(oldList) && !_.isEmpty(oldList) && oldList !== null) {
                                                    oldListCardCount = isNaN(oldList.attributes.card_count) ? 0 : oldList.attributes.card_count;
                                                    oldListCardCount = parseInt(oldListCardCount);
                                                    if (oldListCardCount > 0) {
                                                        oldListCardCount = oldListCardCount - 1;
                                                    }
                                                    App.boards.get(old_card_board_id).lists.get(old_card_list).set('card_count', oldListCardCount);
                                                }
                                            }

                                            var newBoardCard = new App.Card();
                                            newBoardCard.set(cardDetails);
                                            newBoardCard.set('id', parseInt(cardDetails.id));
                                            newBoardCard.set('name', cardDetails.name);
                                            newBoardCard.set('board_id', cardDetails.board_id);
                                            newBoardCard.set('list_id', cardDetails.list_id);
                                            newBoardCard.set('is_archived', parseInt(cardDetails.is_archived));
                                            newBoardCard.set('position', cardDetails.position);
                                            if (!_.isUndefined(App.boards.get(newBoardCard.attributes.board_id))) {
                                                var card_already_exist = App.boards.get(parseInt(newBoardCard.attributes.board_id)).cards.get(parseInt(activity.attributes.card.id));
                                                if (_.isUndefined(card_already_exist) || _.isEmpty(card_already_exist) || card_already_exist === null) {
                                                    App.boards.get(parseInt(newBoardCard.attributes.board_id)).cards.add(newBoardCard);
                                                    newCardList = App.boards.get(new_card_board_id).lists.get(new_card_list);
                                                    if (!_.isUndefined(newCardList) && !_.isEmpty(newCardList) && newCardList !== null) {
                                                        newListCardCount = isNaN(newCardList.attributes.card_count) ? 0 : newCardList.attributes.card_count;
                                                        newListCardCount = parseInt(newListCardCount);
                                                        newListCardCount = newListCardCount + 1;
                                                        App.boards.get(new_card_board_id).lists.get(new_card_list).set('card_count', newListCardCount);
                                                    }
                                                    App.boards.get(new_card_board_id).cards.get(parseInt(cardDetails.id)).set('position', new_card_position);
                                                }
                                            }
                                        }
                                    } else if (activity.attributes.type === 'moved_list_card') {
                                        var cardOldListId = parseInt(activity.attributes.list_id);
                                        var moveCardListId = parseInt(activity.attributes.foreign_id);
                                        var movecardBoard = parseInt(activity.attributes.board_id);
                                        if (!_.isUndefined(App.boards.get(movecardBoard))) {
                                            var moveCards = App.boards.get(movecardBoard).cards.where({
                                                'list_id': cardOldListId
                                            });
                                            var OldCardList = App.boards.get(movecardBoard).lists.get(cardOldListId);
                                            var OldCardListCardCount = 0;
                                            if (!_.isUndefined(OldCardList) && !_.isEmpty(OldCardList) && OldCardList !== null) {
                                                OldCardListCardCount = isNaN(OldCardList.attributes.card_count) ? 0 : OldCardList.attributes.card_count;
                                                OldCardListCardCount = parseInt(OldCardListCardCount);
                                            }
                                            var moveCardList = App.boards.get(movecardBoard).lists.get(moveCardListId);
                                            var moveListCardCount = 0;
                                            if (!_.isUndefined(moveCardList) && !_.isEmpty(moveCardList) && moveCardList !== null) {
                                                moveListCardCount = isNaN(moveCardList.attributes.card_count) ? 0 : moveCardList.attributes.card_count;
                                                moveListCardCount = parseInt(moveListCardCount);
                                                var totalCardCount = OldCardListCardCount + moveListCardCount;
                                                moveCardList.set('card_count', totalCardCount);
                                                if (!_.isUndefined(OldCardList) && !_.isEmpty(OldCardList) && OldCardList !== null) {
                                                    OldCardList.set('card_count', 0);
                                                }
                                                if (!_.isUndefined(moveCards) && !_.isEmpty(moveCards)) {
                                                    _.each(moveCards, function(card) {
                                                        card.set('list_id', moveCardListId);
                                                    });
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Auth = JSON.parse($.cookie('auth'));
                            if (parseInt(activity.attributes.card_id) !== 0 && activity.attributes.token !== authuser.access_token && (parseInt(Auth.user.unread_activity_id) < parseInt(activity.attributes.id) || _.isUndefined(Auth.user.unread_activity_id))) {
                                $('#js-card-' + activity.attributes.card_id).parent().addClass('animation');
                                $('#js-card-' + activity.attributes.card_id).addClass('tada-animation');
                                $('#js-card-' + activity.attributes.card_id).addClass('active');
                                $('#js-card-' + activity.attributes.card_id).stop().animate({
                                    backgroundColor: '#FFFFFF'
                                }, 2000, function() {
                                    $('#js-card-' + activity.attributes.card_id).parent().removeClass('animation');
                                    $('#js-card-' + activity.attributes.card_id).removeClass('tada-animation');
                                    $('#js-card-' + activity.attributes.card_id).removeClass('active');
                                    $('#js-card-' + activity.attributes.card_id).css('background-color', '');
                                });
                            }
                        });
                        localforage.setItem("unreaded_cards", tmp_unreaded_card);
                        if (mode === 2) {
                            var unread_activity_id = _.max(activities.models, function(activity) {
                                return activity.id;
                            });

                            if ($.cookie('auth') && !_.isUndefined(authuser) && !_.isUndefined(authuser.user)) {
                                Auth = JSON.parse($.cookie('auth'));
                                if (!_.isUndefined(Auth.user.unread_activity_id)) {
                                    Auth.user.unread_activity_id = (parseInt(unread_activity_id.id) > parseInt(Auth.user.unread_activity_id) && parseInt(unread_activity_id.id) >= parseInt(Auth.user.last_activity_id)) ? unread_activity_id.id : Auth.user.unread_activity_id;
                                    authuser.user.unread_activity_id = (parseInt(unread_activity_id) > parseInt(Auth.user.unread_activity_id) && parseInt(unread_activity_id.id) >= parseInt(Auth.user.last_activity_id)) ? unread_activity_id.id : Auth.user.unread_activity_id;
                                } else {
                                    Auth.user.unread_activity_id = (parseInt(unread_activity_id.id) >= parseInt(Auth.user.last_activity_id)) ? unread_activity_id.id : Auth.user.last_activity_id;
                                    authuser.user.unread_activity_id = (parseInt(unread_activity_id.id) >= parseInt(Auth.user.last_activity_id)) ? unread_activity_id.id : Auth.user.last_activity_id;
                                }
                                $.cookie('auth', JSON.stringify(Auth));
                            }
                        }
                    } else {
                        if (!_.isUndefined(authuser) && !_.isUndefined(authuser.user) && parseInt(authuser.user.last_activity_id) === 0 || authuser.user.last_activity_id === null) {
                            $('#js-all-activities').parent('div').addClass('notification-empty');
                            $('#js-all-activities').html('<li><div>No activities available.</div></li>');
                            $('#js-notification-load-more-all').hide();
                        }
                    }
                    var headerH = $('header').height();
                    var windowH = $(window).height();
                    var footerH = $('footer').height();
                    var notificationH = windowH - footerH;
                    var boardH = windowH - headerH - footerH - 14;
                    $('.notification-list').css({
                        'height': notificationH - 100,
                        'overflow-y': 'scroll'
                    });
                }
            });
        });
    },
    /**
     * boardActivities()
     * display board activiteis, sync every 10 sec and update the board view.
     * Update the board view based on activity type.
     * @param e
     * @type Object(DOM event)
     *
     */
    boardActivities: function() {
        var view_activity = $('#js-board-activities');
        var self = this;
        var Auth = JSON.parse($.cookie('auth'));
        var clicked_notification_count = 0,
            clicked_all_notification_count = 0;
        var filter = $.cookie('activities_filter');
        if (filter === undefined || filter === 'all') {
            filter = 'all';
        } else if (filter === 'comment') {
            filter = 'comment';
        } else if (filter === 'activity') {
            filter = 'activity';
        }
        if (!_.isUndefined(filter) && filter === 'activity' && !self.$el.find('#modal-activities').hasClass('active')) {
            self.$el.find('#modal-activities').addClass('active');
        } else if (!_.isUndefined(filter) && filter === 'comment' && !self.$el.find('#modal-comments').hasClass('active')) {
            self.$el.find('#modal-comments').addClass('active');
        } else if (_.isUndefined(filter) && !self.$el.find('#modal-activities').hasClass('active') && !self.$el.find('#modal-comments').hasClass('active')) {
            self.$el.find('#modal-activities').addClass('active');
            self.$el.find('#modal-comments').addClass('active');
        }
        var activities = new App.ActivityCollection();
        activities.url = api_url + 'boards/' + authuser.board_id + '/activities.json?mode=' + filter;
        activities.storeName = 'activity';
        $('#js-activity-loader').remove();
        view_activity.append('<li class="col-xs-12" id="js-activity-loader" style="min-height: 200px;"><span class="cssloader"></span></li>');
        if (!_.isUndefined(authuser.user) && _.isUndefined(authuser.user.last_activity_id)) {
            authuser.user.last_activity_id = 0;
        }
        activities.fetch({
            success: function(models, response, options) {
                $('#js-activity-loader').remove();
                if (!_.isEmpty(activities.models)) {
                    activities.each(function(activity) {
                        activity.from_footer = true;
                        var all_activity = $('#js-all-activities');
                        var view = new App.ActivityView({
                            model: activity,
                            board: self.board,
                            flag: '2',
                            type: 'board'
                        });
                        if (activity.attributes.token !== authuser.access_token) {
                            $('.js-unread-activity').parent().addClass('bg-danger navbar-btn');
                        }
                        if ($('.js-list-activity-' + activity.id, view_activity).length === 0) {
                            view_activity.append(view.render().el);
                        }
                    });
                    var unread_activity_id = _.max(activities.models, function(activity) {
                        return activity.id;
                    });
                    if ($.cookie('auth') && !_.isUndefined(authuser) && !_.isUndefined(authuser.user)) {
                        Auth = JSON.parse($.cookie('auth'));
                        if (!_.isUndefined(Auth.user.unread_activity_id)) {
                            Auth.user.unread_activity_id = (parseInt(unread_activity_id.id) > parseInt(Auth.user.unread_activity_id) && parseInt(unread_activity_id.id) >= parseInt(Auth.user.last_activity_id)) ? unread_activity_id.id : Auth.user.unread_activity_id;
                            authuser.user.unread_activity_id = (parseInt(unread_activity_id) > parseInt(Auth.user.unread_activity_id) && parseInt(unread_activity_id.id) >= parseInt(Auth.user.last_activity_id)) ? unread_activity_id.id : Auth.user.unread_activity_id;
                        } else {
                            Auth.user.unread_activity_id = (parseInt(unread_activity_id.id) >= parseInt(Auth.user.last_activity_id)) ? unread_activity_id.id : Auth.user.last_activity_id;
                            authuser.user.unread_activity_id = (parseInt(unread_activity_id.id) >= parseInt(Auth.user.last_activity_id)) ? unread_activity_id.id : Auth.user.last_activity_id;
                        }
                        $.cookie('auth', JSON.stringify(Auth));
                    }
                    var last_board_activity = _.min(activities.models, function(activity) {
                        return activity.id;
                    });
                    load_more_last_board_activity_id = last_board_activity.id;
                    if ($('.js-notification-count').html() > 0 && !_.isUndefined(authuser) && !_.isUndefined(authuser.user)) {
                        var max_last_user_activity = _.max(activities.models, function(activity) {
                            return activity.id;
                        });
                        var user = new App.User();
                        user.url = api_url + 'users/' + authuser.user.id + '.json';
                        user.set('id', parseInt(authuser.user.id));
                        user.save({
                            'last_activity_id': last_board_activity.id
                        });
                        authuser.user.notify_count = 0;
                        Auth.user.notify_count = 0;
                        favicon.badge(0);
                        $('.js-notification-count').addClass('hide');
                        $.cookie('auth', JSON.stringify(Auth));
                    }

                }
                var headerH = $('header').height();
                var windowH = $(window).height();
                var footerH = $('footer').height();
                var notificationH = windowH - footerH;
                var boardH = windowH - headerH - footerH - 14;
                $('.notification-list').css({
                    'height': notificationH - 100,
                    'overflow-y': 'scroll'
                });
            }
        });
    },
    /**
     * notificationMenu()
     * display activiteis
     * @param e
     * @type Object(DOM event)
     *
     */
    notificationMenu: function(e) {
        e.preventDefault();
        if (!_.isUndefined(authuser) && !_.isEmpty(authuser)) {
            if (authuser.board_id !== 0) {
                $('.js-notification-response-container').html(new App.NotificationMenuView({
                    user: authuser
                }).el);
            } else {
                this.userActivities();
            }
        }
    },
    showNotification: function(e) {
        var user;
        if (!_.isUndefined(authuser.user) && !_.isEmpty(authuser.user) && !_.isUndefined(App.current_board) && !_.isEmpty(App.current_board)) {
            user = App.current_board.board_users.findWhere({
                user_id: parseInt(authuser.user.id)
            });
        }
        e.preventDefault();
        $('#js-board-activities, #js-all-activities').empty();
        if (!_.isEmpty(this.board_id) && ((!_.isUndefined(user) && !_.isEmpty(App.current_board.acl_links.where({
                slug: "view_board_activities",
                board_user_role_id: parseInt(user.attributes.board_user_role_id)
            }))) || authuser.user.role_id == 1)) {
            this.$el.find('.js-board-activities').click();
        } else {
            this.$el.find('.js-all-activities').click();
        }
    },
    showBoardActivities: function(e) {
        e.preventDefault();
        var modalView = new App.ModalActivityView({
            model: this.model,
            type: 'board'
        });
        modalView.show();
        return false;
    },
    showUserActivities: function(e) {
        e.preventDefault();
        var modalView = new App.ModalActivityView({
            model: this.model,
            type: 'user'
        });
        modalView.show();
        return false;
    },
    /**
     * loadMore()
     * load more
     * @param e
     * @type Object(DOM event)
     * @mode Object(DOM event)
     * @return false
     */
    loadMore: function(type, mode) {
        var view_activity, query_string = '';
        var self = this;
        var activities = new App.ActivityCollection();
        var filter = $.cookie('activities_filter');
        if (filter === undefined || filter === 'all') {
            filter = 'all';
        } else if (filter === 'comment') {
            filter = 'comment';
        } else if (filter === 'activity') {
            filter = 'activity';
        }
        if (type === 'user') {
            view_activity = $('#js-all-activities');
            query_string = (last_user_activity_id !== 0 && !_.isUndefined(last_user_activity_id)) ? '&last_activity_id=' + last_user_activity_id : '';
            activities.url = api_url + 'users/' + authuser.user.id + '/activities.json?mode=' + filter + '&type=profile' + query_string;
        } else {
            view_activity = $('#js-board-activities');
            query_string = (load_more_last_board_activity_id !== 0 && !_.isUndefined(load_more_last_board_activity_id)) ? '&last_activity_id=' + load_more_last_board_activity_id : '';
            activities.url = api_url + 'boards/' + authuser.board_id + '/activities.json?mode=' + filter + '&type=all' + query_string;
        }
        self.$('#js-empty', view_activity).remove();
        $('#js-activity-loader').remove();
        $('#js-notification-load-more').html('<span class="js-cssloader cssloader"></span>');
        $('#js-notification-load-more-all').html('<span class="js-cssloader cssloader"></span>');
        activities.fetch({
            success: function() {
                $('.js-cssloader, #js-activity-loader').remove();
                $('#js-notification-load-more-all, #js-notification-load-more').text(i18next.t('Load more activities'));
                var last_activity_id = _.min(activities.models, function(activity) {
                    return activity.id;
                });
                if (type === 'user') {
                    last_user_activity_id = last_activity_id.id;
                } else {
                    load_more_last_board_activity_id = last_activity_id.id;
                }
                if (type == 'user') {
                    $('#js-load-link2').removeClass('hide');
                    $('#js-load-link1').addClass('hide');
                } else if (type == 'board') {
                    $('#js-load-link1').removeClass('hide');
                    $('#js-load-link2').addClass('hide');
                }
                if (!_.isEmpty(activities.models)) {
                    $('.notification-list').removeClass('notification-empty');
                    $('.js-empty').remove();
                    modeType = 'all';
                    if (mode == 1) {
                        modeType = '';
                    }
                    activities.each(function(activity) {
                        activity.from_footer = true;
                        var view = new App.ActivityView({
                            model: activity,
                            board: self.board,
                            type: modeType,
                            flag: '2'
                        });
                        $('.js-unread-activity').parent().addClass('bg-danger navbar-btn');
                        view_activity.append(view.render().el);
                    });
                } else {
                    if (type == 'user') {
                        $('#js-load-link').addClass('hide');
                        $('#js-load-link2').addClass('hide');
                    } else if (type == 'board') {
                        $('#js-load-link1').addClass('hide');
                    }
                }
            }
        });
        return false;
    },
    /**
     * enabledesktopNotification()
     * enable desktop notification
     * @param e
     * @type Object(DOM event)
     *
     */
    enabledesktopNotification: function(e) {
        e.preventDefault();
        var self = this;
        if (typeof Notification != 'undefined') {
            Notification.requestPermission(function(permission) {
                // Whatever the user answers, we make sure we store the information
                if (!('permission' in Notification)) {
                    Notification.permission = permission;
                }
                // If the user is okay, let's create a notification
                if (permission === 'granted') {
                    var notification = new Notification('Desktop notification enabled.');
                    location.reload();
                }
            });
        }
    },
    /**
     * showBoardImportForm()
     * show Board Import Form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardImportForm: function(e) {
        e.preventDefault();
        var form = $('#js-board-import');
        $('.js-board-import-file', form).trigger('click');
        return false;
    },
    /**
     * showBoardImportWekanForm()
     * show Board Import Form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardImportWekanForm: function(e) {
        e.preventDefault();
        var form = $('#js-board-import-wekan');
        $('.js-board-import-wekan-file', form).trigger('click');
        return false;
    },
    /**
     * showBoardImportAsanaForm()
     * show Board Import Form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardImportAsanaForm: function(e) {
        e.preventDefault();
        var form = $('#js-board-import-asana');
        $('.js-board-import-asana-file', form).trigger('click');
        return false;
    },
    /**
     * showBoardImportTaskwarriorForm()
     * show Board Import Form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardImportTaskwarriorForm: function(e) {
        e.preventDefault();
        var form = $('#js-board-import-taskwarrior');
        $('.js-board-import-taskwarrior-file', form).trigger('click');
        return false;
    },
    /**
     * showBoardImportKantreeForm()
     * show Board Import Form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardImportKantreeForm: function(e) {
        e.preventDefault();
        var form = $('#js-board-import-kantree');
        $('.js-board-import-kantree-file', form).trigger('click');
        return false;
    },
    /**
     * showBoardImportMondayForm()
     * show Board Import Form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardImportMondayForm: function(e) {
        e.preventDefault();
        var form = $('#js-board-import-monday');
        $('.js-board-import-monday-file', form).trigger('click');
        return false;
    },
    /**
     * showBoardImportTaigaForm()
     * show Board Import Form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardImportTaigaForm: function(e) {
        e.preventDefault();
        var form = $('#js-board-import-taiga');
        $('.js-board-import-taiga-file', form).trigger('click');
        return false;
    },
    /**
     * showBoardImportpipefyForm()
     * show Board Import Form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardImportpipefyForm: function(e) {
        e.preventDefault();
        var form = $('#js-board-import-pipefy');
        $('.js-board-import-pipefy-file', form).trigger('click');
        return false;
    },
    /**
     * importWekanBoard()
     * import Board
     * @param e
     * @type Object(DOM event)
     *
     */
    importWekanBoard: function(e) {
        e.preventDefault();
        $('#js-board-import-wekan-loader').removeClass('hide');
        var self = this;
        var form = $('form#js-board-import-wekan');
        var fileData = new FormData(form[0]);
        var board = new App.Board();
        board.url = api_url + 'boards.json';
        board.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                $('#js-board-import-wekan-loader', '.js-show-board-import-wekan-form').addClass('hide');
            },
            success: function(model, response) {
                $('#js-board-import-wekan-loader', '.js-show-board-import-wekan-form').addClass('hide');
                if (!_.isUndefined(response.id)) {
                    app.navigate('#/board/' + response.id, {
                        trigger: true,
                        replace: true
                    });
                    self.flash('info', i18next.t('Board is been currently imported. Based on the size of file, it may take few seconds to minutes. Please refresh or check after some time..'), 1800000);
                } else {
                    if (response.error) {
                        self.flash('danger', i18next.t(response.error));
                    } else {
                        self.flash('danger', i18next.t('Unable to import. please try again.'));
                    }

                }
            }
        });
    },
    /**
     * importAsanaBoard()
     * import Board
     * @param e
     * @type Object(DOM event)
     *
     */
    importAsanaBoard: function(e) {
        e.preventDefault();
        $('#js-board-import-asana-loader').removeClass('hide');
        var self = this;
        var form = $('form#js-board-import-asana');
        var fileData = new FormData(form[0]);
        var board = new App.Board();
        board.url = api_url + 'boards.json';
        board.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                $('#js-board-import-asana-loader', '.js-show-board-import-asana-form').addClass('hide');
            },
            success: function(model, response) {
                $('#js-board-import-asana-loader', '.js-show-board-import-asana-form').addClass('hide');
                if (!_.isUndefined(response.id)) {
                    app.navigate('#/board/' + response.id, {
                        trigger: true,
                        replace: true
                    });
                    self.flash('info', i18next.t('Board is been currently imported. Based on the size of file, it may take few seconds to minutes. Please refresh or check after some time..'), 1800000);
                } else {
                    if (response.error) {
                        self.flash('danger', i18next.t(response.error));
                    } else {
                        self.flash('danger', i18next.t('Unable to import. please try again.'));
                    }

                }
            }
        });
    },
    /**
     * importTaskwarriorBoard()
     * import Board
     * @param e
     * @type Object(DOM event)
     *
     */
    importTaskwarriorBoard: function(e) {
        e.preventDefault();
        $('#js-board-import-taskwarrior-loader').removeClass('hide');
        var self = this;
        var form = $('form#js-board-import-taskwarrior');
        var fileData = new FormData(form[0]);
        var board = new App.Board();
        board.url = api_url + 'boards.json';
        board.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                $('#js-board-import-taskwarrior-loader', '.js-show-board-import-taskwarrior-form').addClass('hide');
            },
            success: function(model, response) {
                $('#js-board-import-taskwarrior-loader', '.js-show-board-import-taskwarrior-form').addClass('hide');
                if (!_.isUndefined(response.id)) {
                    app.navigate('#/board/' + response.id, {
                        trigger: true,
                        replace: true
                    });
                    self.flash('info', i18next.t('Board is been currently imported. Based on the size of file, it may take few seconds to minutes. Please refresh or check after some time..'), 1800000);
                } else {
                    if (response.error) {
                        self.flash('danger', i18next.t(response.error));
                    } else {
                        self.flash('danger', i18next.t('Unable to import. please try again.'));
                    }

                }
            }
        });
    },
    /**
     * importKantreeBoard()
     * import Board
     * @param e
     * @type Object(DOM event)
     *
     */
    importKantreeBoard: function(e) {
        e.preventDefault();
        $('#js-board-import-kantree-loader').removeClass('hide');
        var self = this;
        var form = $('form#js-board-import-kantree');
        var fileData = new FormData(form[0]);
        var board = new App.Board();
        board.url = api_url + 'boards.json';
        board.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                $('#js-board-import-kantree-loader', '.js-show-board-import-kantree-form').addClass('hide');
            },
            success: function(model, response) {
                $('#js-board-import-kantree-loader', '.js-show-board-import-kantree-form').addClass('hide');
                if (!_.isUndefined(response.id)) {
                    app.navigate('#/board/' + response.id, {
                        trigger: true,
                        replace: true
                    });
                    self.flash('info', i18next.t('Board is been currently imported. Based on the size of file, it may take few seconds to minutes. Please refresh or check after some time..'), 1800000);
                } else {
                    if (response.error) {
                        self.flash('danger', i18next.t(response.error));
                    } else {
                        self.flash('danger', i18next.t('Unable to import. please try again.'));
                    }

                }
            }
        });
    },
    /**
     * importMondayBoard()
     * import Board
     * @param e
     * @type Object(DOM event)
     *
     */
    importMondayBoard: function(e) {
        e.preventDefault();
        $('#js-board-import-monday-loader').removeClass('hide');
        var self = this;
        var form = $('form#js-board-import-monday');
        var fileData = new FormData(form[0]);
        var board = new App.Board();
        board.url = api_url + 'boards.json';
        board.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                $('#js-board-import-monday-loader', '.js-show-board-import-monday-form').addClass('hide');
            },
            success: function(model, response) {
                $('#js-board-import-monday-loader', '.js-show-board-import-monday-form').addClass('hide');
                if (!_.isUndefined(response.msg)) {
                    self.flash('info', i18next.t('Boards are currently imported. Based on the size of the file, it may take a few seconds to minutes. Please refresh or check after some time...'), 1800000);
                } else {
                    if (response.error) {
                        self.flash('danger', i18next.t(response.error));
                    } else {
                        self.flash('danger', i18next.t('Unable to import. please try again.'));
                    }

                }
            }
        });
    },
    /**
     * importTaigaBoard()
     * import Board
     * @param e
     * @type Object(DOM event)
     *
     */
    importTaigaBoard: function(e) {
        e.preventDefault();
        $('#js-board-import-taiga-loader').removeClass('hide');
        var self = this;
        var form = $('form#js-board-import-taiga');
        var fileData = new FormData(form[0]);
        var board = new App.Board();
        board.url = api_url + 'boards.json';
        board.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                $('#js-board-import-taiga-loader', '.js-show-board-import-taiga-form').addClass('hide');
            },
            success: function(model, response) {
                $('#js-board-import-taiga-loader', '.js-show-board-import-taiga-form').addClass('hide');
                if (!_.isUndefined(response.id)) {
                    app.navigate('#/board/' + response.id, {
                        trigger: true,
                        replace: true
                    });
                    self.flash('info', i18next.t('Board is been currently imported. Based on the size of file, it may take few seconds to minutes. Please refresh or check after some time..'), 1800000);
                } else {
                    if (response.error) {
                        self.flash('danger', i18next.t(response.error));
                    } else {
                        self.flash('danger', i18next.t('Unable to import. please try again.'));
                    }

                }
            }
        });
    },
    /**
     * importpipefyBoard()
     * import Board
     * @param e
     * @type Object(DOM event)
     *
     */
    importpipefyBoard: function(e) {
        e.preventDefault();
        $('#js-board-import-pipefy-loader').removeClass('hide');
        var self = this;
        var form = $('form#js-board-import-pipefy');
        var fileData = new FormData(form[0]);
        var board = new App.Board();
        board.url = api_url + 'boards.json';
        board.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                $('#js-board-import-pipefy-loader', '.js-show-board-import-pipefy-form').addClass('hide');
            },
            success: function(model, response) {
                $('#js-board-import-pipefy-loader', '.js-show-board-import-pipefy-form').addClass('hide');
                if (!_.isUndefined(response.id)) {
                    app.navigate('#/board/' + response.id, {
                        trigger: true,
                        replace: true
                    });
                    self.flash('info', i18next.t('Board is been currently imported. Based on the size of file, it may take few seconds to minutes. Please refresh or check after some time..'), 1800000);
                } else {
                    if (response.error) {
                        self.flash('danger', i18next.t(response.error));
                    } else {
                        self.flash('danger', i18next.t('Unable to import. please try again.'));
                    }

                }
            }
        });
    },

    /**
     * importBoard()
     * import Board
     * @param e
     * @type Object(DOM event)
     *
     */
    importBoard: function(e) {
        e.preventDefault();
        $('#js-board-import-loader').removeClass('hide');
        var self = this;
        var form = $('form#js-board-import');
        var fileData = new FormData(form[0]);
        var board = new App.Board();
        board.url = api_url + 'boards.json';
        board.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                $('#js-board-import-loader', '.js-show-board-import-form').addClass('hide');
            },
            success: function(model, response) {
                $('#js-board-import-loader', '.js-show-board-import-form').addClass('hide');
                if (!_.isUndefined(response.id)) {
                    app.navigate('#/board/' + response.id, {
                        trigger: true,
                        replace: true
                    });
                    self.flash('info', i18next.t('Board is been currently imported. Based on the size of file, it may take few seconds to minutes. Please refresh or check after some time..'), 1800000);
                } else {
                    if (response.error) {
                        self.flash('danger', i18next.t(response.error));
                    } else {
                        self.flash('danger', i18next.t('Unable to import. please try again.'));
                    }

                }
            }
        });
    },
    showActivity: function(e) {
        e.preventDefault();
        var i = 0;
        var hide_class = '';
        var target = $(e.currentTarget);
        $('li#no-record').remove();
        if (target.attr('id') == 'modal-activities') {
            $('#all_activities').find('#modal-activities').toggleClass('active');
            if ($('#all_activities').find('#modal-activities').hasClass('active')) {
                if ($('#all_activities').find('#modal-comments').hasClass('active')) {
                    $.cookie('activities_filter', 'all');
                    mode = 'all';
                } else {
                    mode = 'activity';
                    $.cookie('activities_filter', 'activity');
                }
            } else {
                $('#all_activities').find('#modal-activities').find('a[href="#"]').blur();
                if ($('#all_activities').find('#modal-comments').hasClass('active')) {
                    $.cookie('activities_filter', 'comment');
                    mode = 'comment';
                } else {
                    $.cookie('activities_filter', 'all');
                    mode = 'all';
                }
            }
            this.showNotification(e);
        }
        if (target.attr('id') == 'modal-comments') {
            $('#all_activities').find('#modal-comments').toggleClass('active');
            if ($('#all_activities').find('#modal-comments').hasClass('active')) {
                if ($('#all_activities').find('#modal-activities').hasClass('active')) {
                    $.cookie('activities_filter', 'all');
                    mode = 'all';
                } else {
                    $.cookie('activities_filter', 'comment');
                    mode = 'comment';
                }
            } else {
                $('#all_activities').find('#modal-comments').find('a[href="#"]').blur();
                if ($('#all_activities').find('#modal-activities').hasClass('active')) {
                    $.cookie('activities_filter', 'activity');
                    mode = 'activity';
                } else {
                    $.cookie('activities_filter', 'all');
                    mode = 'all';
                }
            }
            this.showNotification(e);
        }
        return false;
    },
    /**
     * showShortcutModal()
     * display the Shortcuts Key
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showShortcutModal: function(e) {
        var modalView = new App.ModalShortcutView({});
        modalView.show();
        return false;
    },
    keyboardShowShortcutModal: function(e) {
        var self = this;
        if (_.isUndefined(self.is_show_keyboard) || self.is_show_keyboard) {
            self.is_show_keyboard = false;
            $('.js-show-shortcuts-modal').trigger('click');
            $('#ModalShortcutView').on('hidden.bs.modal', function() {
                $('#ModalShortcutView').remove();
                self.is_show_keyboard = true;
            });
        }
        return false;
    },
});
