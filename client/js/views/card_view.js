/**
 * @fileOverview This file has functions related to card view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model and its related values
 *	this.model.attachments			: attachments collection(Based on card)
 *	this.model.board_users 			: board users collection(Based on board)
 *  this.model.card_voters			: card users collection(Based on card)
 *  this.model.cards_subscribers	: card subscribers collection(Based on card)
 *	this.model.checklists  			: checklists collection(Based on card)
 *	this.model.labels  				: labels collection(Based on card)
 *	this.model.list  				: list model(Based on card). It contain all list based object @see Available Object in App.ListView
 *	this.model.users				: card users collection(Based on card)
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card View
 * @class CardView
 * @constructor
 * @extends Backbone.View
 */
App.CardView = Backbone.View.extend({
    template: JST['templates/card'],
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(opts) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
            this.model.documentLink = this.documentLink;
        }
        opts = opts || {};
        this.tmp = opts.template;
        this.board_id = opts.board_id;
        this.card_users = [];
        _.bindAll(this, 'render', 'renderListChange');
        if (!_.isUndefined(opts.template)) {
            this.template = JST['templates/card_list_view'];
        }
        if (!_.isEmpty(this.model)) {
            this.model.bind('change:id change:name change:description change:board_id  change:comment_count change:cards_checklists  change:cards_labels change:color change:cards_subscribers  change:due_date change:start_date  change:is_archived change:list_id  change:title change:is_offline change:checklist_item_count change:checklist_item_completed_count change:list_name change:cover_image_id', this.render);
            this.model.bind('change:list_id change:position', this.renderListChange);
            if (this.model.has('list')) {
                this.list = this.model.get('list');
                this.model.unset('list');
            }
            if (this.model.has('card_attachments')) {
                this.model.attachments.add(this.model.get('card_attachments'), {
                    silent: true
                });
            }
            if (this.model.has('cards_checklists')) {
                this.model.checklists.add(this.model.get('cards_checklists'), {
                    silent: true
                });
            }
            if (this.model.has('cards_users')) {
                this.model.users.add(this.model.get('cards_users'), {
                    silent: true
                });
            }
            if (this.model.has('board_users')) {
                this.model.board_users.add(this.model.get('board_users'), {
                    silent: true
                });
            }
            if (this.model.has('cards_voters')) {
                this.model.card_voters.add(this.model.get('cards_voters'), {
                    silent: true
                });
            }
            if (this.model.has('cards_subscribers')) {
                this.model.cards_subscribers.add(this.model.get('cards_subscribers'), {
                    silent: true
                });
            }
            this.model.attachments.bind('add', this.render);
            this.model.attachments.bind('remove', this.render);
            this.model.bind('change:id', this.render);
            this.model.labels.bind('remove', this.render);
            this.model.labels.bind('add', this.render);
            this.model.labels.bind('change', this.render);
            this.model.users.bind('add', this.render);
            this.model.users.bind('add:id', this.render);
            this.model.users.bind('change:id', this.render);
            this.model.users.bind('remove', this.render);
            if (!_.isUndefined(this.model.list) && !_.isUndefined(this.model.list.collection)) {
                this.model.list.collection.board.labels.bind('add', this.render);
            }
            this.model.cards_subscribers.bind('add', this.render);
            if (!_.isUndefined(this.model.board)) {
                this.model.board.bind('change:board_custom_fields', this.render);
            }
            if (!_.isUndefined(this.model.board)) {
                this.model.board.bind('change:is_expand_image_front_of_card', this.render);
            }
            this.model.cards_subscribers.bind('remove', this.render);
            this.model.card_voters.bind('add', this.render);
            this.model.card_voters.bind('remove', this.render);
            if (!_.isUndefined(authuser.user)) {
                var board_user_role_id = this.model.board_users.findWhere({
                    user_id: parseInt(authuser.user.id)
                });
                if (!_.isEmpty(board_user_role_id)) {
                    this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
                }
            }
            this.model.bind('change:is_filtered', function(e) {
                this.render(null);
            }, this);
        }
    },
    className: 'panel js-show-modal-card-view js-board-list-card cur',
    attributes: {
        'data-toggle': 'modal',
        'data-target': '#myModal',
        'href': '#'
    },
    templateAdd: JST['templates/card_add'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-cancel-card-add': 'hideAddCardFrom',
        'click': 'showCardModal',
        'click .js-show-modal-card-view': 'showCardModal',
        'click .js-show-card-action-list': 'showCardActionList',
        'click .js-back-to-card-actions': 'backToCardActions',
        'click .js-show-add-member-form': 'showAddMemberForm',
        'click .js-show-card-label-form': 'showCardLabelForm',
        'click .js-show-card-position-form': 'showCardPositionForm',
        'change .js-change-card-position': 'selectCardPosition',
        'click .js-change-card-position': 'selectCardPosition',
        'change .js-position': 'changeCardPosition',
        'click .js-position': 'changeCardPosition',
        'click .js-add-card-member': 'addCardMember',
        'click .js-remove-card-member': 'removeCardMember',
        'click .js-download-attachments': 'downloadAttachments',
        'cardSort': 'cardSort'
    },
    /**
     * downloadAttachments()
     * download Atttachments
     * @param e
     * @type Object(DOM event)
     * @param data
     * @type Object
     *
     */
    downloadAttachments: function(e) {
        var self = this;
        e.preventDefault();
        var hash = calcMD5(SecuritySalt + 'download' + self.model.attributes.board_id + self.model.id);
        var link = window.location.protocol + '//' + window.location.host + window.location.pathname + 'download/' + self.model.attributes.board_id + '/' + self.model.id + '/' + hash;
        window.open(link);
        return false;
    },
    /**
     * cardSort()
     * save the card moved position
     * @param e
     * @type Object(DOM event)
     * @param data
     * @type Object
     *
     */
    cardSort: function(ev, ui) {
        var self = this;
        var target = $(ev.target);
        var data = {};
        var list_id = parseInt(target.parents('.js-board-list:first').data('list_id'));
        var previous_list_id = self.model.attributes.list_id;
        var previous_card_id = target.prev('.js-board-list-card').data('card_id');
        var next_card_id = target.next('.js-board-list-card').data('card_id');
        var current_board = App.boards.where({
            id: parseInt(self.model.attributes.board_id)
        });
        current_board = current_board['0'];
        var current_list = current_board.lists.findWhere({
            id: parseInt(list_id)
        });
        $('#js-card-listing-' + list_id).find('.js-list-placeholder-' + list_id).remove();
        if (parseInt(current_list.attributes.card_count) === 0 || parseInt(current_list.attributes.card_count) === 1 || _.isUndefined(current_list.attributes.card_count)) {
            $('#js-card-listing-' + list_id).find('.js-list-placeholder-' + list_id).remove();
            /* $('#js-card-listing-' + list_id).html(function(i, h) {
                return h.replace(/&nbsp;/g, '');
            }); */
        }

        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.attributes.id + '.json';
        if ((typeof previous_card_id == 'undefined' && typeof next_card_id == 'undefined') || list_id != self.model.attributes.list_id) {
            data.list_id = list_id;
        }
        if (typeof previous_card_id != 'undefined') {
            self.model.moveAfter(previous_card_id);
        } else if (typeof next_card_id != 'undefined') {
            self.model.moveBefore(next_card_id);
        }
        var change_list = self.model.list.collection.board.lists.findWhere({
            id: list_id
        });
        if (!_.isUndefined(change_list)) {
            self.model.list = change_list;
        }
        var moveCard = App.boards.get(parseInt(self.model.attributes.board_id)).cards.get(parseInt(self.model.attributes.id));
        if (!_.isUndefined(moveCard)) {
            moveCard.set('position', parseFloat(self.model.attributes.position));
            if (list_id != self.model.attributes.list_id) {
                moveCard.set('list_id', list_id);
                App.boards.get(parseInt(self.model.attributes.board_id)).cards.remove(parseInt(self.model.attributes.id));
                App.boards.get(parseInt(self.model.attributes.board_id)).cards.add(moveCard, {
                    silent: true
                });
                moveCard.collection = App.boards.get(parseInt(self.model.attributes.board_id)).cards;
            }
        }
        self.model.set({
            list_id: list_id
        });
        data.position = self.model.attributes.position;
        self.model.save(data, {
            patch: true,
            silent: true,
            success: function(model, response) {
                self.model.set('list_moved_date', response.activity.created);
                var list_moved_date_date_time;
                if (response.activity.created.indexOf('T') != -1) {
                    list_moved_date_date_time = response.activity.created.split('T');
                } else {
                    list_moved_date_date_time = list_moved_date_date_time[0].split(' ');
                }
                if (CheckFieldExists(self.model.board, 'list_moved_date', null, 'boolean', 'r_gridview_configure')) {
                    if ($('#js-card-' + self.model.id).find('.list-moved-date').length === 0) {
                        $('#js-card-' + self.model.id).find('.js-list-card-data').append('<li class="card-listing-truncate list-moved-date"><small title="' + i18next.t('List Moved Date') + '"><span class="label label-default">' + dateFormat(list_moved_date_date_time[0], 'mediumDate') + '</span></small></li>');
                    } else {
                        $('#js-card-' + self.model.id).find('.list-moved-date').html('<small title="' + i18next.t('List Moved Date') + '"><span class="label label-default">' + dateFormat(list_moved_date_date_time[0], 'mediumDate') + '</span></small>');
                    }
                }
                _(function() {
                    if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                        self.model.set('triggersort', true);
                        $('body').trigger('cardRendered', self.model.id, self.model);
                    }
                }).defer();
            }
        });

        var prev_list = current_board.lists.findWhere({
            id: parseInt(previous_list_id)
        });

        var current_board_prev_list = App.current_board.lists.findWhere({
            id: parseInt(previous_list_id)
        });
        var current_board_new_list = App.current_board.lists.findWhere({
            id: parseInt(list_id)
        });
        if (parseInt(list_id) !== parseInt(previous_list_id)) {
            var prev_list_card_count = parseInt(self.model.list.collection.board.lists.get(previous_list_id).get('card_count'));
            var current_list_card_count = parseInt(self.model.list.collection.board.lists.get(list_id).get('card_count'));
            self.model.list.collection.board.lists.get(previous_list_id).cards.remove(self.model);
            self.model.list.collection.board.lists.get(previous_list_id).set('card_count', prev_list_card_count - 1);
            current_board_prev_list.set('card_count', prev_list_card_count - 1);
            prev_list.set('card_count', prev_list_card_count - 1);
            if (parseInt(prev_list.attributes.card_count) === 0) {
                $('#js-card-listing-' + previous_list_id).find('.js-list-placeholder-' + previous_list_id).remove();
                $('#js-card-listing-' + previous_list_id).html('<span class="js-list-placeholder-' + previous_list_id + '">&nbsp;</span>');
                // $('#js-card-listing-' + previous_list_id).html('&nbsp;');
            }
            current_list_card_count = isNaN(current_list_card_count) ? 0 : current_list_card_count;
            self.model.list.collection.board.lists.get(list_id).cards.add(self.model);
            self.model.list.collection.board.lists.get(list_id).set('card_count', current_list_card_count + 1);
            current_board_new_list.set('card_count', current_list_card_count + 1);
            current_list.set('card_count', current_list_card_count + 1);
            _(function() {
                if ((current_list !== null && !_.isUndefined(current_list) && !_.isEmpty(current_list)) && (prev_list !== null && !_.isUndefined(prev_list) && !_.isEmpty(prev_list))) {
                    if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_agile_wip', APPS.enabled_apps) !== -1) {
                        $('body').trigger('cardSortRendered', [current_board_prev_list, current_board_new_list]);
                    }
                }
            }).defer();

            var attachments = self.model.list.collection.board.attachments.where({
                card_id: self.model.attributes.id
            });
            var j = 1;
            _.each(attachments, function(attachment) {
                var options = {
                    silent: true
                };
                if (j === attachments.length) {
                    options.silent = false;
                }
                self.model.list.collection.board.attachments.get(attachment.id).set({
                    list_id: list_id
                }, options);
                j++;
            });
        }
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function(ops) {
        this.converter.setFlavor('github');
        var content = '';
        var self = this;
        var query_params;
        var filter_count = 0;
        var total_filter = 0;
        var filter_label_arr = [],
            filter_user_arr = [],
            filter_color_arr = [],
            filter_due_arr = [];
        var filter_mode;
        var current_param = Backbone.history.fragment.split('?');
        var current_url = current_param[0].split('/');
        var filter = 'grid';
        if (current_url.length === 3 && current_url[2] == 'list') {
            filter = 'list';
        } else if (current_url.length === 3 && current_url[2] == 'gantt') {
            filter = 'gantt';
        }
        if (current_param[1]) {
            query_params = current_param[1].split(',');
            if (query_params[0].indexOf('filter=') !== -1) {
                $('.js-clear-filter-btn').removeClass('hide').addClass('show');
            }
            query_params[0] = query_params[0].replace('filter=', '');
            $.each(query_params, function(index, value) {
                if (value.indexOf('label:') > -1) {
                    total_filter += 1;
                    filter_label_arr.push(value.replace('label:', ''));
                } else if (value.indexOf('color:') > -1) {
                    total_filter += 1;
                    filter_color_arr.push(value.replace('color:', ''));
                } else if (value.indexOf('@') > -1) {
                    total_filter += 1;
                    filter_user_arr.push(value.replace('@', ''));
                } else if (value.indexOf('due:') > -1) {
                    total_filter += 1;
                    filter_due_arr.push(value.replace('due:', ''));
                } else if (value.indexOf('mode:') > -1) {
                    var mode = value.replace('mode:', '');
                    if (mode === 'and') {
                        filter_mode = 'and';
                    }
                }
            });
        }
        if (!_.isUndefined(authuser.user) && self.model !== null && !_.isEmpty(self.model) && !_.isUndefined(self.model)) {
            var board_user_role_id;
            if (!_.isUndefined(this.model.board_users) && this.model.board_users.length > 0) {
                board_user_role_id = this.model.board_users.findWhere({
                    user_id: parseInt(authuser.user.id)
                });
            } else if (!_.isUndefined(this.model.list) && !_.isUndefined(this.model.list.board_users) && this.model.list.board_users.length > 0) {
                board_user_role_id = this.model.list.board_users.findWhere({
                    user_id: parseInt(authuser.user.id)
                });
            }
            if (!_.isEmpty(board_user_role_id)) {
                this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
            }
        }
        if (_.isUndefined(this.tmp) && self.model !== null && !_.isEmpty(self.model) && !_.isUndefined(this.model.list) && !_.isUndefined(this.model.list.collection)) {
            filter_count = 0;
            content += '<ul class="unstyled  hide js-card-labels">';
            var filtered_labels = this.model.list.collection.board.labels.where({
                card_id: self.model.id
            });
            var labels = new App.CardLabelCollection();
            labels.add(filtered_labels);
            labels.setSortField('id', 'asc');
            labels.sort();
            labels.each(function(label) {
                if (_.escape(label.attributes.name) !== "") {
                    content += '<li class="' + _.escape(label.attributes.name) + '">' + _.escape(label.attributes.name) + '</li>';
                }
            });
            content += '</ul>';
            this.$el.html(content);
            $(content).find('li').each(function(key, value) {
                if (!_.isEmpty(filter_mode)) {
                    if (filter_mode === 'and') {
                        if ($.inArray($(value).text(), filter_label_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                } else {
                    if (filter_label_arr.length != 1) {
                        $(filter_label_arr).each(function(key, label) {
                            if ($.inArray($(value).text(), filter_label_arr) !== -1) {
                                filter_count += 1;
                            }
                        });
                    } else {
                        if ($.inArray($(value).text(), filter_label_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                }
            });
            content = '<ul class="unstyled  js-card-colors hide">';
            if (this.model.attributes.color !== null && this.model.attributes.color !== undefined) {
                var card_color = this.model.attributes.color.replace('#', '');
                content += '<li>' + card_color + '</li>';
            }
            content += '</ul>';
            this.$el.append(content);
            $(content).find('li').each(function(key, value) {
                if (!_.isEmpty(filter_mode)) {
                    if (filter_mode === 'and') {
                        if ($.inArray($(value).text(), filter_color_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                } else {
                    if (filter_color_arr.length != 1) {
                        $(filter_color_arr).each(function(key, label) {
                            if ($.inArray($(value).text(), filter_color_arr) !== -1) {
                                filter_count += 1;
                            }
                        });
                    } else {
                        if ($.inArray($(value).text(), filter_color_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                }
            });

            content = '<ul class="unstyled  js-card-users hide">';
            this.model.users.each(function(user) {
                content += '<li>' + user.get('username') + '</li>';
            });
            content += '</ul>';
            this.$el.append(content);
            $(content).find('li').each(function(key, value) {
                if (!_.isEmpty(filter_mode)) {
                    if (filter_mode === 'and') {
                        if ($.inArray($(value).text(), filter_user_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                } else {
                    if (filter_user_arr.length != 1) {
                        $(filter_user_arr).each(function(key, label) {
                            if ($.inArray($(value).text(), filter_user_arr) !== -1) {
                                filter_count += 1;
                            }
                        });
                    } else {
                        if ($.inArray($(value).text(), filter_user_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                }
            });
            content = '<ul class="unstyled  js-card-due hide">';
            content += this.getDue(this.model.get('due_date'));
            content += '</ul>';
            this.$el.append(content);
            $(content).find('li').each(function(key, value) {
                if ($.inArray($(value).text(), filter_due_arr) !== -1) {
                    filter_count += 1;
                }
            });
            this.$el.append(this.template({
                card: this.model,
                converter: this.converter
            }));
            if (filter_count < total_filter && (query_params)) {
                if (_.isUndefined(ops) && ops !== null) {
                    this.model.set('is_filtered', true);
                    this.$el.addClass('hide');
                }
            }
            if (!_.isUndefined(this.model.attributes.name) && this.model.attributes.name !== '') {
                this.$el.addClass('panel js-show-modal-card-view js-board-list-card non-select cur').removeAttr('id').attr('data-toggle', 'modal').attr('data-target', '#myModal').attr('data-card_id', this.model.id).attr('id', 'js-card-' + this.model.id).css("border-left-color", this.model.attributes.color);
                if (!_.isUndefined(this.model.attributes.color) && !_.isEmpty(this.model.attributes.color) && this.model.attributes.color !== null) {
                    this.$el.css("border-left-width", "8px");
                }
            }
        } else if (self.model !== null && !_.isEmpty(self.model) && !_.isUndefined(self.model.attributes.id) && !_.isUndefined(this.model.list) && !_.isUndefined(this.model.list.collection)) {
            filter_count = 0;
            content += '<ul class="unstyled  hide js-card-labels">';
            var filtered_card_labels = this.model.list.collection.board.labels.where({
                card_id: self.model.id
            });
            var card_labels = new App.CardLabelCollection();
            card_labels.add(filtered_card_labels);
            card_labels.setSortField('id', 'asc');
            card_labels.sort();
            var card_labels_length = card_labels.models.length;
            for (var card_labels_i = 0; card_labels_i < card_labels_length; card_labels_i++) {
                var label = card_labels.models[card_labels_i];
                if (_.escape(label.attributes.name) !== "") {
                    content += '<li class="' + _.escape(label.attributes.name) + '">' + _.escape(label.attributes.name) + '</li>';
                }
            }
            content += '</ul>';
            this.$el.html(content);
            $(content).find('li').each(function(key, value) {
                if (!_.isEmpty(filter_mode)) {
                    if (filter_mode === 'and') {
                        if ($.inArray($(value).text(), filter_label_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                } else {
                    if (filter_label_arr.length != 1) {
                        $(filter_label_arr).each(function(key, label) {
                            if ($.inArray($(value).text(), filter_label_arr) !== -1) {
                                filter_count += 1;
                            }
                        });
                    } else {
                        if ($.inArray($(value).text(), filter_label_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                }
            });
            content = '<ul class="unstyled  js-card-users hide">';
            var users = this.model.users;
            var card_users_length = users.models.length;
            for (var card_users_i = 0; card_users_i < card_users_length; card_users_i++) {
                var user = users.models[card_users_i];
                content += '<li>' + user.attributes.username + '</li>';
            }
            content += '</ul>';
            this.$el.append(content);
            $(content).find('li').each(function(key, value) {
                if (!_.isEmpty(filter_mode)) {
                    if (filter_mode === 'and') {
                        if ($.inArray($(value).text(), filter_user_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                } else {
                    if (filter_user_arr.length != 1) {
                        $(filter_user_arr).each(function(key, label) {
                            if ($.inArray($(value).text(), filter_user_arr) !== -1) {
                                filter_count += 1;
                            }
                        });
                    } else {
                        if ($.inArray($(value).text(), filter_user_arr) !== -1) {
                            filter_count += 1;
                        }
                    }
                }
            });
            content = '<ul class="unstyled  js-card-due hide">';
            content += this.getDue(this.model.get('due_date'));
            content += '</ul>';
            this.$el.append(content);
            $(content).find('li').each(function(key, value) {
                if ($.inArray($(value).text(), filter_due_arr) !== -1) {
                    filter_count += 1;
                }
            });
            this.$el.append(self.template({
                card: self.model,
                converter: this.converter
            }));
            if (!_.isUndefined(this.model.attributes.name) && this.model.attributes.name !== '') {
                this.$el.addClass('panel js-show-modal-card-view js-board-list-card non-select cur').removeAttr('id').attr('data-toggle', 'modal').attr('data-target', '#myModal').attr('data-card_id', this.model.id).attr('id', 'js-card-' + this.model.id).css("border-left-color", this.model.attributes.color);
                if (!_.isUndefined(this.model.attributes.color) && !_.isEmpty(this.model.attributes.color) && this.model.attributes.color !== null) {
                    this.$el.css("border-left-width", "8px");
                }
            }
            if (filter_count < total_filter && (query_params)) {
                if (_.isUndefined(ops) && ops !== null) {
                    this.model.set('is_filtered', true, {
                        silent: true
                    });
                    this.$el.addClass('hide');
                }
            }
        } else if (self.model === null) {
            $('.js-card-list-view-' + this.board_id).html(this.$el.append(self.template({
                card: self.model
            })));
            if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_custom_fields', APPS.enabled_apps) !== -1) {
                if (!_.isUndefined(App.current_board) && !_.isEmpty(App.current_board) && !_.isUndefined(App.current_board.attributes.custom_fields) && App.current_board.attributes.custom_fields !== null) {
                    var table_heads_count = $('#listview_table thead').find('th').length;
                    $('#listview_table tbody').html('<tr><td colspan="' + table_heads_count + '"  class="text-center alert alert-info">' + i18next.t('No %s available.', {
                        postProcess: 'sprintf',
                        sprintf: [i18next.t('cards')]
                    }) + '</td></tr>');
                }
            }
        }
        if (self.model !== null && !_.isUndefined(self.model) && self.model.get('is_filtered')) {
            self.$el.addClass('hide');
        } else {
            self.$el.removeClass('hide');
        }
        _(function() {
            if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                $('body').trigger('cardRendered', self.model.id, self.model);
                localforage.getItem('unreaded_cards', function(err, value) {
                    if (value) {
                        if (value[self.model.id]) {
                            if ($('#js-card-' + self.model.id).find('.js-unread-notification').length === 0) {
                                $('#js-card-' + self.model.id).find('.js-list-card-data').prepend('<li class="js-unread-notification"><small title = "' + i18next.t('unread notifications') + '"><span class="label label-primary"><span class="icon-bell"></span><span>' + value[self.model.id] + '</span></span></small>');
                            } else {
                                $('#js-card-' + self.model.id).find('.js-unread-notification').html('<small title = "' + i18next.t('unread notifications') + '"><span class="label label-primary"><span class="icon-bell"></span><span>' + value[self.model.id] + '</span></span></small>');
                            }
                        }
                    }
                });
            }
            if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_listview_configure', APPS.enabled_apps) !== -1) {
                self.sortLabelPosition();
            }

        }).defer();
        return this;
    },
    /* sortLabelPosition()
     * sort the list view fields 
     * @param e
     * @type Object(DOM event)
     *
     */
    sortLabelPosition: function() {
        if (!_.isUndefined(this) && !_.isEmpty(this) && !_.isUndefined(this.model) && !_.isEmpty(this.model)) {
            var board_id = this.model.get('board_id');
            var wrapper = $('.js-card-list-view-' + board_id + ' #js-card-' + this.model.id),
                items = wrapper.children(),
                r_listview_configure_positions, temp_dom = [];
            if (!_.isUndefined(this.model.board) && !_.isEmpty(this.model.board) && !_.isUndefined(this.model.board.attributes.board_custom_fields) && !_.isEmpty(this.model.board.attributes.board_custom_fields)) {
                board_custom_fields = JSON.parse(this.model.board.attributes.board_custom_fields);
                if (!_.isUndefined(board_custom_fields.r_listview_configure_position) && !_.isUndefined(board_custom_fields.r_listview_configure_position)) {
                    r_listview_configure_positions = board_custom_fields.r_listview_configure_position.split(',');
                    items.each(function(label, key) {
                        temp_dom.push(key.id);
                    });
                    wrapper.prepend($.map(r_listview_configure_positions, function(v) {
                        var list_index = temp_dom.findIndex(function(item) {
                            return item === 'list_view_config_data-' + v;
                        });
                        return items[list_index];
                    }));
                }
            }
        }
    },
    /**
     * renderAdd()
     * render card add form
     * @return object
     *
     */
    renderAdd: function() {
        this.$el.html(this.templateAdd({
            model: this.model
        }));
        return this;
    },
    /**
     * hideAddCardFrom()
     * hide card add form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    hideAddCardFrom: function(e) {
        $('#js-list-card-add-form-' + this.model.attributes.list_id).remove();
        $('#js-card-listing-' + this.model.attributes.list_id).css("height", '100%');
        $('.js-show-add-card-form', $('#js-card-listing-' + this.model.attributes.list_id).next()).removeClass('hide');
        return false;
    },
    /**
     * addCard()
     * add card to list
     * @param e
     * @type Object(DOM event)
     *
     */
    addCard: function(e) {
        e.preventDefault();
        var self = this;
        var data = $(e.target).parents('form.js-cardAddForm').serializeObject();
        if (data.selected_list_id !== undefined) {
            data.list_id = data.selected_list_id;
        }
        $('.js-show-add-card-form', $('#js-card-listing-' + this.model.attributes.list_id).next()).removeClass('hide');
        self.model.unset('list');
        self.model.set(data);
        this.list.cards.push(self.model);
        self.model.collection.add(self.model);
        self.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards.json';
        self.model.save({}, {
            success: function(model, response) {
                self.model.set('id', parseInt(response.id));
                self.list.collection.board.activities.unshift(response.activity);
            }
        });
    },
    /**
     * selectCardPosition()
     * change position based on selected list
     * @param string
     * @type string
     */
    selectCardPosition: function(e) {
        e.preventDefault();
        e.stopPropagation();
        _(function() {
            $(e.target).parents('.dropdown').addClass('open');
        }).defer();
        var target = $(e.currentTarget);
        var self = this;
        var list_id = target.val();
        var board_id = $(e.target).parents('form.js-cardAddForm').find('.js-selected-board').val();
        var content_position = '';
        self.$el.find('.js-card-add-list').val(list_id);
        var list = this.model.list.collection.board.lists.findWhere({
            id: parseInt(list_id)
        });
        var filtered_cards_count = this.model.list.collection.board.cards.where({
            list_id: list.attributes.id,
            is_archived: 0
        }).length;
        var current_position = filtered_cards_count + 1;
        for (var i = 1; i <= filtered_cards_count; i++) {
            content_position += '<option value="' + i + '">' + i + '</option>';
        }
        self.$el.find('.js-card-add-position').val(i);
        content_position += '<option value="' + i + '" selected="selected">' + i + ' ' + i18next.t('(current)') + '</option>';
        self.$el.find('.js-position').html(content_position);
        return false;
    },
    /**
     * changeCardPosition()
     * change position based on selected list
     * @param string
     * @type string
     */
    changeCardPosition: function(e) {
        e.preventDefault();
        e.stopPropagation();
        _(function() {
            $(e.target).parents('.dropdown').addClass('open');
        }).defer();
        var target = $(e.currentTarget);
        var posoition = target.val();
        this.$el.find('.js-card-add-position').val(posoition);
        return false;

    },
    /**
     * showCardModal()
     * show card detail in docmodal
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showCardModal: function(e) {
        $('ul.dropdown-menu').parent().removeClass('open');
        if (this.model === null || _.isEmpty(this.model)) {
            return false;
        }
        if (!_.isEmpty(this.model.attributes.name)) {
            changeTitle(i18next.t('%s on %s', {
                postProcess: 'sprintf',
                sprintf: [_.escape(this.model.attributes.name), _.escape(this.model.list.collection.board.attributes.name)]
            }), true);
        }
        if (!_.isUndefined(authuser.user) && (_.isUndefined(this.model.board_user_role_id) || _.isEmpty(this.model.board_user_role_id) || this.model.board_user_role_id === null)) {
            var board_user_role_id = this.model.board_users.findWhere({
                user_id: parseInt(authuser.user.id)
            });
            if (!_.isEmpty(board_user_role_id)) {
                this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
            }
        }
        var current_param = Backbone.history.fragment;
        current_param = current_param.split('?');
        var filter_param = '';
        if (current_param[1]) {
            filter_param = '?' + current_param[1];
        }
        current_param = current_param[0];
        if (!_.isUndefined(this.model.id) && (card_ids_ref[0] === 0 || _.indexOf(card_ids_ref, this.model.id) === -1)) {
            if (!card_ids_ref) {
                card_ids_ref = [];
            }
            card_ids_ref.push(this.model.id);
            if (current_param.indexOf('/card/') != -1) {
                current_param += ',' + this.model.id;
            } else {
                current_param += '/card/' + this.model.id;
            }
            current_param = current_param.replace('/board', 'board');
            app.navigate('#/' + current_param + filter_param, {
                trigger: false,
                trigger_function: false,
            });
        }
        var initialState = (DEFAULT_CARD_VIEW === 'Maximized') ? 'modal' : 'docked';
        if (!_.isUndefined(e) && (e.ctrlKey || e.metaKey)) {
            initialState = 'modal';
        }
        var triggerdock = this.$el.attr('data-triggerModal');
        if (!_.isUndefined(triggerdock) && triggerdock !== null) {
            initialState = 'docked';
        }
        if (!_.isUndefined(this.model.id)) {
            var modalView = new App.ModalCardView({
                model: this.model,
                initialState: initialState
            });
            var view_card = this.$('#js-card-listing-' + this.model.id);
            view_card.html('<span class="js-list-placeholder-' + this.model.id + '">&nbsp;</span>');
            modalView.show();
            return false;
        }
    },
    /**
     * getDue()
     * show card due date
     * @param card_due_date
     * @type String
     * @return message
     * @type String
     *
     */
    getDue: function(card_due_date) {
        if (card_due_date === null) {
            return '';
        }
        var today = new Date();
        var last_day = new Date(today.getFullYear(), today.getMonth() + 1, 0);
        var next_month_last_day = new Date(today.getFullYear(), today.getMonth() + 2, 0);
        var due_date = new Date(card_due_date);
        var diff = Math.floor(due_date.getTime() - today.getTime());

        var day = 1000 * 60 * 60 * 24;
        var days = Math.floor(diff / day);
        var months = Math.floor((days + (today.getDate() + 1)) / next_month_last_day.getDate());

        var years = Math.floor(months / 12);
        var week = days - (6 - (today.getDay()));
        var due_content = '';
        var message = 'feature';
        due_content = '';
        if (years > 0) {
            message = 'year';
            due_content += '<li>year</li>';
        }
        if (days >= 0 && days <= 7) {
            message = 'week';
            due_content += '<li>week</li>';
        }
        if (days >= 0 && days <= 30) {
            message = 'month';
            due_content += '<li>month</li>';
        }
        if (days === 0) {
            message = 'day';
            due_content += '<li>day</li>';
        }
        if (years < 0 || months < 0 || days <= -1) {
            message = 'overdue';
            due_content += '<li>overdue</li>';
        }
        return due_content;
    },
    /**
     * showCardActionList()
     * render card actions
     * @param e
     * @type Object(DOM event)
     *
     */
    showCardActionList: function(e) {
        e.preventDefault();
        $(e.currentTarget).next().remove();
        $(e.currentTarget).after(new App.CardActionsView({
            model: this.model
        }).el);
    },
    /**
     * showAddMemberForm()
     * show card member add form
     * @param e
     * @type Object(DOM event)
     * return false
     *
     */
    showAddMemberForm: function(e) {
        e.preventDefault();
        $('.js-card-action-list-response').html(new App.CardMemberFormView({
            model: this.model
        }).el);
        this.showTooltip();
        var selected_members = $('.js-card-user-ids').val();
        var selected_members_arr = selected_members.split(",");
        for (i = 0; i < selected_members_arr.length; i++) {
            target = $('.js-add-card-member[data-user-id="' + selected_members_arr[i] + '"]');
            target.removeClass('js-add-card-member').addClass('js-remove-card-member');
            target.append('<i class="icon-ok"></i>');
        }
        return false;
    },
    /**
     * showCardLabelForm()
     * show card label add form
     * @param e
     * @type Object(DOM event)
     * return false
     *
     */
    showCardLabelForm: function(e) {
        $('.js-card-template-checking').remove();
        var labels = $('.js-card-add-labels').val();
        $('.js-card-action-list-response').html(new App.CardLabelsFormView({
            model: labels
        }).el);
        if (_.isUndefined(labels) || _.isEmpty(labels)) {
            labels = [];
        } else {
            labels = labels.split(',');
        }
        var self = this;
        var labelPluckerData = self.model.collection.list.board.labels.invoke('pick', ['name', 'color']);
        var tagColors = {};
        if (labelPluckerData.length > 0) {
            labelPluckerData.forEach(function(value) {
                tagColors[value.name] = value.color;
            });
        }
        $('.inputCardLabel').select2({
            tags: _.uniq(self.model.collection.list.board.labels.pluck('name')),
            tagColors: tagColors,
            tokenSeparators: [',', ' ']
        }).on('select2-selecting', function(e) {
            if (!_.isEmpty(e.choice.text)) {
                var labels = _.pluck(self.$('.inputCardLabel').select2('data'), 'text');
                labels.push(e.choice.text);
                self.$el.find('.js-card-add-labels').val(labels.join(','));
                var labelColor;
                if (!_.isEmpty(tagColors) && !_.isUndefined(tagColors[e.choice.text]) && tagColors[e.choice.text] !== null && !_.isEmpty(tagColors[e.choice.text])) {
                    labelColor = tagColors[e.choice.text];
                } else {
                    labelColor = '#' + calcMD5("" + e.choice.text).slice(0, 6).substring(0, 6);
                }
                var iTag = '<i style="color:' + labelColor + '" data-toggle="tooltip" data-container="body" data-placement="top" data-original-title="' + e.choice.text + '" title="' + e.choice.text + '" class="js-label-' + e.choice.text + ' ' + LABEL_ICON + '"></i>';
                $('.js-lables-list').append(iTag);
            }
        }).on('select2-removed', function(e) {
            var _labels = _.pluck(self.$('.inputCardLabel').select2('data'), 'text');
            self.$el.find('.js-card-add-labels').val(_labels.join(','));
            $('.js-lables-list').children().remove('.js-label-' + e.choice.text);
        });
        return false;
    },
    /**
     * showCardPositionForm()
     * show card position add form
     * @param e
     * @type Object(DOM event)
     * return false
     *
     */
    showCardPositionForm: function(e) {
        $('.js-card-template-checking').remove();
        e.preventDefault();
        $('.js-card-action-list-response').html(new App.CardPositionsFormView({
            model: this.model,
            boards: App.boards
        }).el);
        return false;
    },
    /**
     * backToCardActions()
     * display card actions list
     * @param e
     * @type Object(DOM event)
     * return false
     *
     */
    backToCardActions: function(e) {
        e.preventDefault();
        e.stopPropagation();
        $('a.js-show-card-action-list').next().remove();
        $('a.js-show-card-action-list').after(new App.CardActionsView({
            model: this.model
        }).el);
        return false;
    },
    /**
     * getLabelcolor()
     * generate color code
     * @param string
     * @type string
     * @return color code
     * @type string
     */
    getLabelcolor: function(string) {
        return calcMD5(string).slice(0, 6);
    },
    /**
     * showCardPositionForm()
     * show card position add form
     * @param e
     * @type Object(DOM event)
     * return false
     *
     */
    addCardMember: function(e) {
        var target = $(e.currentTarget);
        var self = this;
        target.removeClass('js-add-card-member').addClass('js-remove-card-member');
        target.append('<i class="icon-ok"></i>');
        var user_id = target.data('user-id');
        this.card_users.push(parseInt(user_id));
        $.unique(this.card_users);
        var get_val = this.$el.find('.js-card-user-ids').val();
        if (!_.isEmpty(get_val)) {
            this.$el.find('.js-card-user-ids').val(get_val + ',' + user_id);
        } else {
            this.$el.find('.js-card-user-ids').val(user_id);
        }
        var user_data = target.data();
        var profile = '<i class="avatar avatar-color-194 img-rounded">' + user_data.userInitial + '</i>';
        if (!_.isEmpty(user_data.userProfilePicturePath)) {
            var profile_picture_path = self.model.showImage('User', user_id, 'small_thumb');
            profile = '<img src="' + profile_picture_path + '" alt="[Image: ' + user_data.userName + ']" title="' + user_data.userFullname + ' (' + user_data.userFullname + ')" class="img-rounded img-responsive avatar">';
        }
        var iTag = '<li class="js-tooltip navbar-btn js-users-list-' + user_id + '" data-container="body" data-placement="bottom" title="" data-toggle="tooltip" data-original-title="' + user_data.userFullname + ' (' + user_data.userFullname + ')">' + profile + '</li>';
        self.$el.find('.js-users-list').find('ul').append(iTag);
        return false;
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
        $.unique(this.card_users);
        this.card_users.splice($.inArray(parseInt(user_id), this.card_users), 1);
        var get_val = $('.js-card-user-ids').val();
        var explode = get_val.split(',');
        var final_ids = jQuery.grep(explode, function(value) {
            return value != user_id;
        });
        this.$el.find('.js-card-user-ids').val(final_ids.join(','));
        self.$el.find('.js-users-list').find('ul').children().remove('.js-users-list-' + user_id);
        return false;
    },
    /**
     * renderListChange()
     * renderListChange
     * @param e
     * @type Object(DOM event)
     *
     */
    renderListChange: function() {
        this.$el.remove();
        this.render();
    }
});
