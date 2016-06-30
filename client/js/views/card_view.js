/**
 * @fileOverview This file has functions related to card view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model and it's related values
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
    converter: new showdown.Converter(),
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(opts) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
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
            this.model.bind('change:id change:name change:description change:board_id  change:cards_checklists  change:cards_labels  change:cards_subscribers  change:is_archived  change:due_date change:list_id  change:title change:checklist_item_completed_count change:checklist_item_count change:is_offline', this.render);
            this.model.bind('change:list_id', this.renderListChange);
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
            this.model.bind('change:id', this.render);
            this.model.attachments.bind('remove', this.render);
            this.model.labels.bind('remove', this.render);
            this.model.labels.bind('add', this.render);
            this.model.labels.bind('change', this.render);
            this.model.users.bind('add', this.render);
            this.model.users.bind('add:id', this.render);
            this.model.users.bind('change:id', this.render);
            this.model.users.bind('remove', this.render);
            if (!_.isUndefined(this.model.list)) {
                this.model.list.collection.board.labels.bind('add', this.render);
                this.model.list.collection.board.labels.bind('remove', this.render);
                this.model.list.collection.board.activities.bind('add remove', this.render);
            }
            this.model.cards_subscribers.bind('add', this.render);
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
        'cardSort': 'cardSort'
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
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.attributes.id + '.json';
        if ((typeof previous_card_id == 'undefined' && typeof next_card_id == 'undefined') || list_id != self.model.attributes.list_id) {
            data.list_id = list_id;
        }
        if (typeof previous_card_id != 'undefined') {
            self.model.moveAfter(previous_card_id);
        } else if (typeof next_card_id != 'undefined') {
            self.model.moveBefore(next_card_id);
        }
        self.model.set({
            list_id: list_id
        }, {
            silent: true
        });
        data.position = self.model.attributes.position;
        self.model.save(data, {
            patch: true,
            silent: true
        });
        self.model.list.collection.board.lists.get(previous_list_id).cards.remove(self.model);
        self.model.list.collection.board.lists.get(list_id).cards.add(self.model);
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
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function(ops) {
        var content = '';
        var self = this;
        if (_.isUndefined(this.tmp) && self.model !== null && !_.isEmpty(self.model) && !_.isUndefined(this.model.list) && !_.isUndefined(this.model.list.collection)) {
            content += '<ul class="unstyled  hide js-card-labels">';
            var filtered_labels = this.model.list.collection.board.labels.where({
                card_id: self.model.id
            });
            var labels = new App.CardLabelCollection();
            labels.add(filtered_labels);
            labels.each(function(label) {
                if (_.escape(label.attributes.name) !== "") {
                    content += '<li class="' + _.escape(label.attributes.name) + '">' + _.escape(label.attributes.name) + '</li>';
                }
            });
            content += '</ul>';
            this.$el.html(content);
            content = '<ul class="unstyled  js-card-users hide">';
            this.model.users.each(function(user) {
                content += '<li>user-filter-' + user.get('user_id') + '</li>';
            });
            content += '</ul>';
            this.$el.append(content);
            content = '<ul class="unstyled  js-card-due hide">';
            content += this.getDue(this.model.get('due_date'));
            content += '</ul>';
            this.$el.append(content);
            this.$el.append(this.template({
                card: this.model,
                converter: this.converter
            }));
            if (!_.isUndefined(this.model.attributes.name) && this.model.attributes.name !== '') {
                this.$el.addClass('panel js-show-modal-card-view js-board-list-card cur').removeAttr('id').attr('data-toggle', 'modal').attr('data-target', '#myModal').attr('data-card_id', this.model.id).attr('id', 'js-card-' + this.model.id);
            }
        } else if (self.model !== null && !_.isEmpty(self.model) && !_.isUndefined(self.model.attributes.id) && !_.isUndefined(this.model.list) && !_.isUndefined(this.model.list.collection)) {
            content += '<ul class="unstyled  hide js-card-labels">';
            var filtered_card_labels = this.model.list.collection.board.labels.where({
                card_id: self.model.id
            });
            var card_labels = new App.CardLabelCollection();
            card_labels.add(filtered_card_labels);
            var card_labels_length = card_labels.models.length;
            for (var card_labels_i = 0; card_labels_i < card_labels_length; card_labels_i++) {
                var label = card_labels.models[card_labels_i];
                if (_.escape(label.attributes.name) !== "") {
                    content += '<li class="' + _.escape(label.attributes.name) + '">' + _.escape(label.attributes.name) + '</li>';
                }
            }
            content += '</ul>';
            this.$el.html(content);
            content = '<ul class="unstyled  js-card-users hide">';
            var users = this.model.users;
            var card_users_length = users.models.length;
            for (var card_users_i = 0; card_users_i < card_users_length; card_users_i++) {
                var user = users.models[card_users_i];
                content += '<li>user-filter-' + user.attributes.user_id + '</li>';
            }
            content += '</ul>';
            this.$el.append(content);
            content = '<ul class="unstyled  js-card-due hide">';
            content += this.getDue(this.model.get('due_date'));
            content += '</ul>';
            this.$el.append(content);
            this.$el.append(self.template({
                card: self.model
            }));
        } else if (self.model === null) {
            $('.js-card-list-view-' + this.board_id).html(this.$el.append(self.template({
                card: self.model
            })));
        }
        return this;
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
            changeTitle(i18next.t('Card - %s on %s', {
                postProcess: 'sprintf',
                sprintf: [_.escape(this.model.attributes.name), _.escape(this.model.list.collection.board.attributes.name)]
            }));
        }
        var current_param = Backbone.history.fragment;
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
            app.navigate('#/' + current_param, {
                trigger: false,
                trigger_function: false,
            });
        }
        var initialState = (DEFAULT_CARD_VIEW === 'Maximized') ? 'modal' : 'docked';
        if (e.ctrlKey || e.metaKey) {
            initialState = 'modal';
        }
        if (!_.isUndefined(this.model.id)) {
            var modalView = new App.ModalCardView({
                model: this.model,
                initialState: initialState
            });
            var view_card = this.$('#js-card-listing-' + this.model.id);
            view_card.html('&nbsp;');
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
        var selected_memebers = $('.js-card-user-ids').val();
        var selected_memebers_arr = selected_memebers.split(",");
        for (i = 0; i < selected_memebers_arr.length; i++) {
            target = $('.js-add-card-member[data-user-id="' + selected_memebers_arr[i] + '"]');
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
        var self = this;
        $('.js-card-action-list-response').html(new App.CardLabelsFormView({
            model: this.model
        }).el);
        $('.js-card-label').select2({
            tags: this.model.list.collection.board.labels.pluck('name'),
            tokenSeparators: [',', ' ']
        }).on('select2-selecting', function(e) {
            var labels = _.pluck(self.$('.js-card-label').select2('data'), 'text');
            labels.push(e.choice.text);
            self.$el.find('.js-card-add-labels').val(labels.join(','));
            var iTag = '<i style="color:#' + calcMD5("" + e.choice.text).slice(0, 6).substring(0, 6) + '" data-toggle="tooltip" data-container="body" data-placement="top" data-original-title="' + e.choice.text + '" title="' + e.choice.text + '" class="js-label-' + e.choice.text + ' ' + LABEL_ICON + '"></i>';
            $('.js-lables-list').append(iTag);
        }).on('select2-removed', function(e) {
            var _labels = _.pluck(self.$('.js-card-label').select2('data'), 'text');
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
        target.removeClass('js-add-card-member').addClass('js-remove-card-member');
        target.append('<i class="icon-ok"></i>');
        var user_id = target.data('user-id');
        this.card_users.push(parseInt(user_id));
        $.unique(this.card_users);
        this.$el.find('.js-card-user-ids').val(this.card_users.join(','));
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
        this.$el.find('.js-card-user-ids').val(this.card_users.join(','));
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
