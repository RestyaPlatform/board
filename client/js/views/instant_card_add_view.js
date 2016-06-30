/**
 * @fileOverview This file has functions related to instant card add labels form view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: instant card add model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * InstantCardAdd View
 * @class InstantCardAddView
 * @constructor
 * @extends Backbone.View
 */
App.InstantCardAddView = Backbone.View.extend({
    template: JST['templates/instant_card_add'],
    converter: new showdown.Converter(),
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form.js-instantCardAddForm': 'addInstantCard',
        'keyup .js-search-users': 'showSearchUsers',
        'click .js-close-popover': 'closePopup',
        'click .js-add-card-member': 'addCardMember',
        'click .js-remove-card-member': 'removeCardMember',
        'click .js-show-card-label-form': 'showCardLabelForm',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        _.bindAll(this, 'render');
        this.board = options.board;
        this.boards = new App.BoardCollection();
        this.card_users = [];
        this.card_users_names = [];
        this.render();
    },
    className: 'js-instant-card-from',
    tagName: 'div',
    attributes: {
        'title': i18next.t('Instant Add Card')
    },
    bindings: {
        '#board_id': {
            observe: 'board_id',
            initialize: function($el) {
                $el.select2({
                    width: 175,
                    allowClear: true
                });
            },
            selectOptions: {
                collection: function() {
                    var board_arr = [];
                    _.each(this.boards.models, function(board) {
                        if (!_.isEmpty(board.attributes.lists) && board.attributes.lists.length > 0 && parseInt(board.attributes.is_closed) === 0) {
                            var temp = {};
                            temp.id = board.id;
                            temp.name = _.escape(board.attributes.name);
                            board_arr.push(temp);
                        }
                    });
                    return board_arr;
                },
                valuePath: 'id',
                labelPath: 'name',
                defaultOption: {
                    label: '',
                    value: null
                }
            },
            onSet: function(val) {
                this.model.set('list_id', null);
                $('#list_id').select2('val', null);
                this.showCardLabelForm();
                return val;
            }
        },
        '#list_id': {
            observe: ['list_id', 'board_id'],
            initialize: function($el) {
                $el.select2({
                    width: 175,
                    allowClear: true
                });
            },
            selectOptions: {
                collection: function() {
                    var boardId = this.model.get('board_id');
                    var board = this.boards.findWhere({
                        id: parseInt(boardId)
                    });
                    this.$('.js-instant-card-user-ids').val('');
                    this.$('.js-instant-card-member-search-response').nextAll().remove();
                    this.$('#inputInstantCardAddUserSearch').val('');
                    $('<li class="small"><div class="col-xs-12">' + i18next.t('Search for a person in %s by name or email address.', {
                        postProcess: 'sprintf',
                        sprintf: [SITE_NAME]
                    }) + '</div></li>').insertAfter(this.$('.js-instant-card-member-search-response'));
                    var list_arr = [];
                    if (!_.isUndefined(board)) {
                        _.each(board.attributes.lists, function(list) {
                            if (parseInt(list.is_archived) === 0) {
                                var list_temp = {};
                                list_temp.id = list.id;
                                list_temp.name = _.escape(list.name);
                                list_arr.push(list_temp);
                            }
                        });
                    }
                    return list_arr;
                },
                valuePath: 'id',
                labelPath: 'name',
                defaultOption: {
                    label: '',
                    value: null
                }
            },
            onSet: function(val) {
                this.model.set('list_id', val);
                $('#list_id').select2('val', val);
                return val;
            }
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
        this.boards = App.boards;
        var _id = 'js-instant-card-from-' + $('.js-instant-card-from').length;
        this.id = _id;
        var self = this;
        $('.js-hidden-blocks').append(this.$el.html(this.template({
            boards: this.boards
        })).attr('title', i18next.t('Instant Add Card')));
        this.$el.dockmodal({
            initialState: 'docked',
            height: 300,
            width: 400,
            animationSpeed: ANIMATION_SPEED,
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
        }).find('.js-chosen-select').select2();
        this.$el.find('.duedate').datetimepicker({
            format: 'yyyy-mm-dd hh:ii:ss',
            autoclose: true,
            todayBtn: true,
            pickerPosition: 'top-right',
            todayHighlight: 1,
            bootcssVer: 3,
            pickTime: true
        }).on('changeDate', function(ev) {
            var date = new Date(ev.date);
            var year = date.getFullYear();
            var month = date.getMonth();
            var day = date.getDate();
            var hour = date.getHours();
            var minute = date.getMinutes();
            var second = date.getSeconds();
            var formattedTime = year + '-' + (month + 1) + '-' + day + ' ' + hour + ':' + minute + ':' + second;
            var formattedTimeToolTip = dateFormat(formattedTime, 'mmm dd yyyy h:MM TT');
            self.$('.js-instant-date').addClass('text-primary').parent().addClass('js-tooltip').attr('title', formattedTimeToolTip);
            $('.js-tooltip').tooltip();
            self.$('.js-instant-duedate').val(formattedTime);
        });
        this.stickit(this.model, this.bindings);
        this.showCardLabelForm();
        this.showTooltip();
        return this;
    },
    /**
     * addInstantCard()
     * add card
     * @param e
     * @type Object(DOM event)
     *
     */
    addInstantCard: function(e) {
        e.preventDefault();
        this.card_users = [];
        this.card_users_names = [];
        $('li.dropdown').removeClass('open');
        var self = this;
        var data = $(e.target).serializeObject();
        if (data.board_id === 'undefined' || data.board_id === '') {
            $('#board_id').select2('open');
        } else if (data.list_id === 'undefined' || data.list_id === '') {
            $('#list_id').select2('open');
        }
        if (data.board_id && data.list_id) {
            $('input[type!="submit"], textarea, select', $(e.currentTarget)).val('').removeAttr('checked').removeAttr('selected');
            $('#board_id, #list_id').select2('val', null);
            var card = new App.Card();
            var board_id = parseInt(data.board_id);
            data.board_id = board_id;
            var list_id = parseInt(data.list_id);
            data.list_id = list_id;
            card.url = api_url + 'boards/' + data.board_id + '/lists/' + data.list_id + '/cards.json';
            card.set('is_archived', 0);
            card.set(data);
            card.set('board_id', board_id);
            card.set('due_date', null);
            card.set('checklist_item_count', 0);
            card.set('checklist_item_completed_count', 0);
            if (!_.isUndefined(self.board) && board_id === self.board.id) {
                card.list = self.board.lists.findWhere({
                    id: list_id
                });
                var view = new App.CardView({
                    tagName: 'div',
                    model: card,
                    converter: this.converter
                });
                $('#js-card-listing-' + list_id).append(view.render().el);
            }
            this.$('.js-instant-user').removeClass('text-primary').parent().removeClass('js-tooltip').attr('data-original-title', '').attr('title', '');
            this.$('.js-instant-label').removeClass('text-primary').parent().removeClass('js-tooltip').attr('data-original-title', '').attr('title', '');
            this.$('.js-instant-date').removeClass('text-primary').parent().removeClass('js-tooltip').attr('data-original-title', '').attr('title', '');
            $(e.target)[0].reset();
            card.save(data, {
                success: function(model, response) {
                    if (!_.isUndefined(response.id)) {
                        card.set('list_id', parseInt(data.list_id));
                        card.set('id', parseInt(response.id));
                        if (!_.isUndefined(self.board) && board_id === self.board.id) {
                            self.board.cards.add(card);
                            self.board.lists.get(parseInt(data.list_id)).cards.add(card);
                            if (!_.isUndefined(response.cards_labels)) {
                                var _i = 1;
                                _.each(response.cards_labels, function(label) {
                                    var new_label = new App.Label();
                                    new_label.set(label);
                                    new_label.set('id', parseInt(label.id));
                                    new_label.set('label_id', parseInt(label.label_id));
                                    new_label.set('card_id', parseInt(label.card_id));
                                    new_label.set('list_id', parseInt(label.list_id));
                                    new_label.set('board_id', parseInt(label.board_id));
                                    var options = {
                                        silent: true
                                    };
                                    if (_i === response.cards_labels.length) {
                                        options.silent = false;
                                    }
                                    self.board.labels.add(new_label, options);
                                    _i++;
                                });
                            }
                        } else {
                            var card_count = App.boards.get(board_id).lists.get(parseInt(data.list_id)).get('card_count');
                            App.boards.get(board_id).lists.get(parseInt(data.list_id)).set('card_count', card_count + 1);
                            if (this.model !== null) {
                                App.boards.get(board_id).lists.sortByColumn('position');
                                data = [];
                                var color_codes = ['#DB7093', '#F47564', '#EDA287', '#FAC1AD', '#FFE4E1', '#D3ABF0', '#DC9CDC', '#69BFBA', '#66CDAA', '#8FBC8F', '#CBFDCA', '#EEE8AA', '#BC8F8F', '#CD853F', '#D2B48C', '#F5DEB3', '#64BCF2', '#87CEFA', '#B0C4DE', '#D6E2F7'];
                                var i = 0;
                                App.boards.get(board_id).lists.each(function(list) {
                                    if (!list.attributes.is_archived) {
                                        var _data = {};
                                        _data.title = list.attributes.name;
                                        _data.value = list.attributes.card_count;
                                        _data.color = color_codes[i];
                                        i++;
                                        if (i > 20) {
                                            i = 0;
                                        }
                                        if (list.attributes.card_count > 0) {
                                            data.push(_data);
                                        }
                                    }
                                });
                                var _this = this;
                                _(function() {
                                    var starred_board = $('#js-starred-board-' + board_id);
                                    var my_board = $('#js-my-board-' + board_id);
                                    if (starred_board.length > 0) {
                                        starred_board.find('.js-chart').html('').drawDoughnutChart(data);
                                    }
                                    if (my_board.length > 0) {
                                        my_board.find('.js-chart').html('').drawDoughnutChart(data);
                                    }
                                }).defer();
                            }
                        }
                    } else {
                        self.flash('danger', i18next.t('You don\'t have permission to add a card'));
                    }
                }
            });
        }
    },
    /**
     * showSearchUsers()
     * display searched users
     * @param e
     * @type Object(DOM event)
     *
     */
    showSearchUsers: function(e) {
        var self = this;
        var q = $(e.target).val();
        var users = new App.UserCollection();
        var board_id = $('#board_id').val();
        if (board_id !== 0) {
            users.url = api_url + 'users/search.json?board_id=' + board_id;
        } else {
            users.url = api_url + 'users/search.json';
        }
        users.fetch({
            data: {
                q: q
            },
            success: function() {
                self.$el.find('.js-instant-card-member-search-response').nextAll().remove();
                _.each(users.models, function(user) {
                    var is_added_user = ($.inArray(user.id, self.card_users) !== -1) ? true : false;
                    $('<li>' + new App.CardSearchUsersResultView({
                        model: user,
                        is_added_user: is_added_user
                    }).el + '</li>').insertAfter(self.$el.find('.js-instant-card-member-search-response'));
                });
                if (users.models.length === 0) {
                    $('<li>' + new App.CardSearchUsersResultView({
                        model: null,
                    }).el + '</li>').insertAfter(self.$el.find('.js-instant-card-member-search-response'));
                }
            }
        });
    },
    /**
     * closePopup()
     * hide opened dropdown
     * @param e
     * @type Object(DOM event)
     *
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        target.parents('li.dropup').removeClass('open');
        return false;
    },
    /**
     * addCardMember()
     * add card member
     * @param e
     * @type Object(DOM event)
     *
     */
    addCardMember: function(e) {
        e.preventDefault();
        var target = $(e.currentTarget);
        target.removeClass('js-add-card-member').addClass('js-remove-card-member');
        target.append('<i class="icon-ok"></i>');
        var user_id = target.data('user-id');
        var user_name = target.data('user-name');
        this.card_users.push(parseInt(user_id));
        this.card_users_names.push(user_name);
        $.unique(this.card_users);
        $.unique(this.card_users_names);
        this.$('.js-instant-user').addClass('text-primary').parent().addClass('js-tooltip').attr('data-original-title', this.card_users_names.join(',')).attr('title', this.card_users_names.join(','));
        $('.js-tooltip').tooltip();
        this.$('.js-instant-card-user-ids').val(this.card_users.join(','));
    },
    /**
     * removeCardMember()
     * remove card member
     * @param e
     * @type Object(DOM event)
     *
     */
    removeCardMember: function(e) {
        e.preventDefault();
        var target = $(e.currentTarget);
        target.removeClass('js-remove-card-member').addClass('js-add-card-member');
        target.find('i.icon-ok').remove();
        var user_id = target.data('user-id');
        var user_name = target.data('user-name');
        $.unique(this.card_users);
        this.card_users.splice($.inArray(parseInt(user_id), this.card_users), 1);
        this.card_users_names.splice($.inArray(user_name, this.card_users_names), 1);
        this.$('.js-instant-user').parent().addClass('js-tooltip').attr('data-original-title', this.card_users_names.join(',')).attr('title', this.card_users_names.join(','));
        $('.js-tooltip').tooltip();
        if (this.card_users.length === 0) {
            this.$('.js-instant-user').removeClass('text-primary').parent().removeClass('js-tooltip').attr('data-original-title', '').attr('title', i18next.t('Users'));
        }
        this.$('.js-card-user-ids').val(this.card_users.join(','));
    },
    /**
     * showCardLabelForm()
     * display card label add form
     * @param e
     * @type Object(DOM event)
     *
     */
    showCardLabelForm: function() {
        var board = App.boards.findWhere({
            id: parseInt(this.$el.find('#board_id').val())
        });
        var labels = new App.CardLabelCollection();
        if (!_.isEmpty(board) && !_.isEmpty(board.attributes.labels)) {
            labels.set(board.attributes.labels);
        }
        $('.js-show-instant-card-label-form-response').html(new App.InstantCardAddLabelsFormView({
            model: this.model
        }).el);
        var self = this;
        this.$('.js-card-label').select2({
            tags: labels.pluck('name'),
            tokenSeparators: [',', ' ']
        }).on('select2-selecting', function(e) {
            var labels = _.pluck(self.$('.js-card-label').select2('data'), 'text');
            labels.push(e.choice.text);
            self.$('.js-instant-label').addClass('text-primary').parent().addClass('js-tooltip').attr('data-original-title', labels.join(',')).attr('title', labels.join(','));
            $('.js-tooltip').tooltip();
        }).on('select2-removed', function(e) {
            var _labels = _.pluck(self.$('.js-card-label').select2('data'), 'text');
            self.$('.js-instant-label').parent().attr('data-original-title', _labels.join(',')).attr('title', _labels.join(','));
            if (self.$('.js-card-label').select2('data').length === 0) {
                self.$('.js-instant-label').removeClass('text-primary').parent().removeClass('js-tooltip').attr('data-original-title', '').attr('title', i18next.t('Labels'));
            }
        });
    }
});
