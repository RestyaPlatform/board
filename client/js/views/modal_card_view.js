/**
 * @fileOverview This file has functions related to dockmodal card view. This view calling from card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model and it's related values
 *	this.model.attachments			: attachments collection(Based on card)
 *	this.model.board_users 			: board users collection(Based on board)
 *  this.model.card_voters			: card users collection(Based on card)
 *  this.model.cards_subscribers	: card subscribers collection(Based on card)
 *	this.model.checklists  			: checklists collection(Based on card)
 *	this.model.labels  				: labels collection(Based on card)
 *	this.model.list  				: list model(Based on card).mar It contain all list based object @see Available Object in App.ListView
 *	this.model.users				: card users collection(Based on card)
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ModalCard View
 * @class ModalCardView
 * @constructor
 * @extends Backbone.View
 */
App.ModalCardView = Backbone.View.extend({
    id: 'base-modal',
    className: '',
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
    template: JST['templates/modal_card_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-open-popover': 'openPopup',
        'click .js-show-card-title-edit-form': 'showCardTitleEditForm',
        'click .js-cancel-card-title-edit': 'cancelCardTitleEditForm',
        'submit form.js-card-edit-form': 'editCard',
        'click .js-show-card-desc-edit-form': 'showCardDescEditForm',
        'click .js-show-description': 'showCardDesc',
        'click .js-preview-description': 'previewCardDesc',
        'click .js-cancel-card-description-edit': 'cancelCardDescEditForm',
        'click .js-show-card-due-date-form': 'showCardDueDateForm',
        'submit form.js-card-label-add-form': 'addCardLabel',
        'click .js-show-card-label-form': 'showCardLabelForm',
        'click .js-add-card-vote': 'addCardVote',
        'click .js-delete-card-vote': 'deleteCardVote',
        'click .js-card-subscribe': 'cardSubscribe',
        'click .js-card-unsubscribe': 'cardUnsubscribe',
        'click .js-show-move-card-form': 'showMoveCardForm',
        'submit form.js-move-card': 'moveCard',
        'click .js-archive-card': 'archiveCard',
        'click .js-card-send-to-board': 'cardSendToBoard',
        'click .js-delete-card': 'deleteCard',
        'click a.js-attachment-dropbox-open': 'dropboxChooser',
        'click a.js-attachment-computer-open': 'computerOpen',
        'change .js-card-attachment': 'addCardAttachment',
        'click .js-show-checklist-add-form': 'showChecklistAddForm',
        'submit form.js-add-checklist': 'addChecklist',
        'click .js-show-add-member-form': 'showAddMemberForm',
        'click .js-add-card-member': 'addCardMember',
        'click .js-remove-card-member': 'removeCardMember',
        'click .js-remove-due-date': 'removeDueDate',
        'change .js-change-list': 'changeList',
        'change .js-change-position': 'changePosition',
        'click .js-show-copy-card-form': 'showCopyCardForm',
        'submit .js-copy-card': 'copyCard',
        'click .js-more-dropdown': 'showMoreForm',
        'click .js-select-card-url': 'selectCardURL',
        'click .js-show-add-comment-form': 'showAddCommentForm',
        'submit form.js-add-comment': 'addComment',
        'click .js-show-edit-activity': 'showEditCommentForm',
        'submit form.js-edit-comment': 'editComment',
        'click .js-hide-edit-comment-form': 'hideEditCommentForm',
        'click .js-show-confirm-comment-delete': 'showConfirmCommentDelete',
        'click .js-delete-comment': 'deleteComment',
        'click .js-show-reply-activity-form': 'showReplyCommentForm',
        'click .js-hide-reply-comment-form': 'hideReplyCommentForm',
        'submit .js-card-attachment-link-form': 'addCardAttachmentLink',
        'click .js-show-card-voters-list': 'showCardVotersList',
        'keyup .js-search-card': 'showSearchCards',
        'click .js-add-comment-card': 'AddCommentCard',
        'keyup .js-search-member': 'showSearchMembers',
        'click .js-add-comment-member': 'AddCommentMember',
        'focus .js-comment': 'showActions',
        'keyup .js-comment': 'showMemberSearch',
        'keydown .js-comment': 'showMemberSearchKeyDown',
        'keyup .js-search-users': 'showSearchUsers',
        'click .js-load-dropbox': 'loadDropbox',
        'click .js-no-action': 'noAction',
        'click .js-show-side-card-title-edit-form': 'showSideCardTitleEditForm',
        'click .js-open-dropdown': 'openDropdown',
        'keypress input[type=text]': 'onEnter',
        'click .js-show-emoji-list': 'showEmojiList',
        'click .js-comment-add-emoji': 'addEmoji',
        'click .js-checklist-item-add-emoji': 'addChecklistItemEmoji',
        'click #modal-comments': 'showActivity',
        'click #modal-activities': 'showActivity',
        'keypress[c] .dockmodal': 'keyboardArchiveCard',
        'keyup[d] .dockmodal': 'keyboardShowCardDueDateForm',
        'keyup[t] .dockmodal': 'keyboardShowCardTitleEditForm',
        'keyup[v] .dockmodal': 'keyboardAddCardVote',
        'keyup[s] .dockmodal': 'keyboardCardSubscribe',
        'keyup[m] .dockmodal': 'keyboardShowAddMemberForm',
        'keyup[l] .dockmodal': 'keyboardShowCardLabelForm',
        'keyup[space] .dockmodal': 'keyboardAddCardMember',
        'click .js-print-screen': 'printScreen',
        'click .js-color-focusout-card': 'colorPickerCard',
        'click .js-show-color-settings': 'showColorPicker',
        'click .js-remove-card-color': 'removeCardColor',
        'click .js-show-comment': 'showComment',
        'click .js-preview-comment': 'previewComment',
        'click .js-card-activites-load-more': 'cardActivityLoadMore',
        'mouseenter .js-close-drag': 'CloseDragDrop'
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if ($('.modalChatHistoryView').hasClass('in')) {
            $('.modalChatHistoryView').modal('hide');
        }
        this.initialState = options.initialState;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        var self = this;
        _.bindAll(this, 'render', 'renderChecklistsCollection', 'renderAttachmentsCollection', 'renderUsersCollection', 'refreshdock');
        this.model.bind('change:users change:name  change:description  change:board_id  change:cards_checklists  change:cards_labels  change:cards_subscribers  change:is_archived  change:due_date change:start_date change:list_id  change:title', this.refreshdock);
        this.model.cards_subscribers.bind('add remove', this.refreshdock);
        this.model.checklists.bind('remove', this.renderChecklistsCollection);
        this.model.checklists.bind('add', this.renderChecklistsCollection);
        this.model.checklists.bind('change:name', this.renderChecklistsCollection);
        this.model.list.collection.board.checklists.bind('remove', this.renderChecklistsCollection);
        this.model.list.collection.board.checklists.bind('add', this.renderChecklistsCollection);
        this.model.list.collection.board.checklist_items.bind('add', this.renderChecklistsCollection);
        this.model.list.collection.board.checklist_items.bind('change:is_completed', this.renderChecklistsCollection);
        this.model.list.collection.board.checklist_items.bind('remove', this.renderChecklistsCollection);
        self.authuser = authuser.user;
        this.model.card_voters.bind('add', this.refreshdock);
        this.model.card_voters.bind('remove', this.refreshdock);
        this.model.attachments.bind('add', this.renderAttachmentsCollection);
        this.model.attachments.bind('remove', this.renderAttachmentsCollection);
        this.board = self.model.list.collection.board;
        _(this).bindAll('show');
        this.boards = App.boards;
        this.DROPBOX_APPKEY = DROPBOX_APPKEY;
    },
    /**
     * showComment()
     * show textarea for comment
     * @param e
     * @type Object(DOM event)
     *
     */
    showComment: function(e) {
        e.preventDefault();
        var target = e.currentTarget;
        var cardId = $(target).attr("data-id");
        if (!$('.show-comment-' + cardId).hasClass('active')) {
            $('.show-comment-' + cardId).addClass('active');
            $('.preview-comment-' + cardId).removeClass('active');
        }
        $(target).parents('#card_activities').find('textarea#inputAddComment').removeClass('hide').addClass('show');
        $(target).parents('#card_activities').find('.js-card-comment-preview-panel').removeClass('show').addClass('hide');
    },
    /**
     * previewComment()
     * show html formatted comment
     * @param e
     * @type Object(DOM event)
     *
     */
    previewComment: function(e) {
        e.preventDefault();
        var target = e.currentTarget;
        var cardId = $(target).attr("data-id");
        $('.show-comment-' + cardId).removeClass('active');
        $('.preview-comment-' + cardId).addClass('active');
        if ($(target).parents('#card_activities').find('textarea#inputAddComment').hasClass('show')) {
            $(target).parents('#card_activities').find('textarea#inputAddComment').removeClass('show').addClass('hide');
        } else {
            $(target).parents('#card_activities').find('textarea#inputAddComment').addClass('hide');
        }
        var value = $(target).parents('#card_activities').find('textarea#inputAddComment').val();
        if (value !== "") {
            $(target).parents('#card_activities').find('.js-card-comment-preview').html(this.converter.makeHtml(value));
        } else {
            $(target).parents('#card_activities').find('.js-card-comment-preview').html("<p>Nothing to preview</p>");
        }
        $(target).parents('#card_activities').find('.js-card-comment-preview-panel').removeClass('hide').addClass('show');
    },
    /**
     * showColorPicker()
     * show color picker
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showColorPicker: function(e) {
        e.preventDefault();
        $(e.target).parents('.js-dropdown-submenu, .docmodal-submenu').addClass('open');
        $('.js-show-color-settings-dropdown').addClass('open');
        return false;
    },
    /**
     * removeCardColor()
     * add selected card in lis
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    removeCardColor: function(e) {
        var color_label = '';
        var data = {
            color: color_label
        };
        var self = this;
        var card_id = self.model.id;
        $('#js-card-color-demo-' + card_id).css("background-color", color_label);
        $('#js-card-' + card_id).css("border-left-color", color_label).css("border-left-width", "8px");
        $('#js-carousel-card-' + card_id).css("border-left", '5px solid ' + color_label);
        $('.js-remove-card-color').addClass('hide');
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '.json';
        self.model.save(data, {
            patch: true,
            success: function(model, response) {}
        });
        return false;
    },
    /**
     * colorPicker()
     * add selected card in lis
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    colorPickerCard: function(e) {
        var color_label = $(e.target).closest('li').data('color');
        var data = {
            color: color_label
        };
        var self = this;
        var card_id = self.model.id;
        $('#js-card-color-demo-' + card_id).css("background-color", color_label);
        $('#js-card-' + card_id).css("border-left-color", color_label).css("border-left-width", "8px");
        $('#js-carousel-card-' + card_id).css("border-left", '5px solid ' + color_label);
        $('.js-remove-card-color').removeClass('hide');
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '.json';
        self.model.save(data, {
            patch: true,
            success: function(model, response) {}
        });
        return false;
    },
    /**
     * drop()
     * handle card sorting(save card position) and image upload
     * @param event
     * @type Object(DOM event)
     * @param data
     * @type Object
     *
     */
    drop: function(event, data) {
        event.stopPropagation();
        event.preventDefault();
        if (!_.isUndefined(event.originalEvent)) {
            var files = event.originalEvent.dataTransfer.files;
            this.processFiles(files, event.currentTarget.dataset.card_id);
        }
        return false;
    },
    /**
     * dragover()
     * prevent default event action
     * @param e
     * @type Object(DOM event)
     */
    dragover: function(e) {
        e.stopPropagation();
        e.preventDefault();
    },
    /**
     * processFiles()
     * handle dropped image
     * @param files
     * @type Object(DOM event)
     * @param card_id
     * @type integer
     */
    processFiles: function(files, card_id) {
        _.each(files, function(file) {
            this.processFile(file, card_id);
        }, this);
    },
    /**
     * processFile()
     * saved dropped images
     * @param file
     * @type Object(DOM event)
     * @param card_id
     * @type integer
     *
     */
    processFile: function(file, card_id) {
        var fileData = new FormData();
        fileData.append('attachment', file);
        var card_attachment = new App.CardAttachment();
        card_attachment.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '/attachments.json';
        card_attachment.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false
        });
    },
    /**
     * printScreen()
     * Print card
     * @param file
     * @type Object(DOM event)
     * @param card_id
     * @type integer
     *
     */
    printScreen: function() {
        $('.printable').print();
    },
    /**
     * showEmojiList()
     * Show the emoji list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showEmojiList: function(e) {
        e.preventDefault();
        var emojiList = "smile,thumbsup,warning,sunglasses";
        var emojiListArray = emojiList.split(",");
        $('.js-show-emoji-list-response ul').remove();
        $('.js-show-emoji-list-response').append(new App.EmojiListView({
            model: emojiListArray
        }).el);
        $('.js-comment-emoji-search-response').parent('ul').addClass("emoji-scroll");
        emojify.run();
    },
    /**
     * addEmoji()
     * Add emoji in comment
     * @param e
     * @type Object(DOM event)
     */
    addEmoji: function(e) {
        e.preventDefault();
        var target = $(e.currentTarget);
        if ($(target).parents('.js-add-comment').length > 0) {
            $(target).parents('.js-add-comment').find('.js-comment').val($(target).parents('.js-add-comment').find('.js-comment').val() + ':' + target.text() + ': ');
        } else {
            $(target).parents('.js-edit-comment').find('.js-comment').val($(target).parents('.js-edit-comment').find('.js-comment').val() + ':' + target.text() + ': ');
        }
    },
    /**
     * addChecklistItemEmoji()
     * Add emoji in comment
     * @param e
     * @type Object(DOM event)
     */
    addChecklistItemEmoji: function(e) {
        e.preventDefault();
        var target = $(e.currentTarget);
        this.$el.find('#ChecklistItem').val(this.$el.find('#ChecklistItem').val() + ':' + target.text() + ': ');
    },
    /**
     * hideActivity()
     * Hide activity and comment
     * @param e
     * @type Object(DOM event)
     */
    showActivity: function(e) {
        e.preventDefault();
        var self = this;
        var i = 0;
        var hide_class = '';
        var target = $(e.currentTarget);
        var mode = 'all';
        $('li#no-record').remove();
        if (target.attr('id') == 'modal-activities') {
            self.$el.find('#modal-activities').toggleClass('active');
            if (self.$el.find('#modal-activities').hasClass('active')) {
                if (self.$el.find('#modal-comments').hasClass('active')) {
                    mode = 'all';
                    $.cookie('filter', 'all');
                } else {
                    mode = 'activity';
                    $.cookie('filter', 'activity');
                }
            } else {
                if (self.$el.find('#modal-comments').hasClass('active')) {
                    mode = 'comment';
                    $.cookie('filter', 'comment');
                } else {
                    mode = 'all';
                    $.cookie('filter', 'all');
                }
            }
        }
        if (target.attr('id') == 'modal-comments') {
            self.$el.find('#modal-comments').toggleClass('active');
            if (self.$el.find('#modal-comments').hasClass('active')) {
                if (self.$el.find('#modal-activities').hasClass('active')) {
                    mode = 'all';
                    $.cookie('filter', 'all');
                } else {
                    mode = 'comment';
                    $.cookie('filter', 'comment');
                }
            } else {
                if (self.$el.find('#modal-activities').hasClass('active')) {
                    mode = 'activity';
                    $.cookie('filter', 'activity');
                } else {
                    mode = 'all';
                    $.cookie('filter', 'all');
                }
            }
        }
        $('#js-card-modal-' + this.model.id).find('.js-load-more-block').remove();
        var view_activity = $('#js-card-activities-' + this.model.id);
        view_activity.html('');
        self.model.activities = new App.ActivityCollection();
        self.model.activities.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '/activities.json?mode=' + mode;
        self.model.activities.fetch({
            cache: false,
            success: function(model, response) {
                self.model.set('activity_count', response._metadata.total_records);
                self.renderActivitiesCollection();
            }
        });
        return false;
    },
    /** 
     * addCardLabel()  
     * save card labels 
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    addCardLabel: function(e) {
        e.preventDefault();
        var self = this;
        var target = $(e.target);
        var data = target.serializeObject();
        data.uuid = new Date().getTime();
        target.parents('li.dropdown').removeClass('open');
        var filtered_labels = self.model.list.collection.board.labels.where({
            card_id: self.model.id
        });
        var labels = new App.CardLabelCollection();
        labels.add(filtered_labels);
        labels.each(function(label) {
            self.model.list.collection.board.labels.remove(label, {
                silent: true
            });
            self.model.labels.remove(label, {
                silent: true
            });
        });
        var card_label = new App.Label();
        card_label.set('is_offline', true);
        card_label.set('board_id', self.model.attributes.board_id);
        card_label.set('list_id', self.model.attributes.list_id);
        card_label.set('card_id', self.model.id);
        var newLabelList = data.name;
        var oldLabelList = data.hiddenName;
        card_label.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/labels.json';
        card_label.save(data, {
            success: function(model, response, options) {
                if (_.isUndefined(options.temp_id)) {
                    card_label.set('is_offline', false);
                }
                if (!_.isUndefined(response.id) && _.isUndefined(options.temp_id)) {
                    card_label.set({
                        id: parseInt(response.id)
                    });
                } else {
                    global_uuid[data.uuid] = options.temp_id;
                    card_label.set('id', data.uuid);
                }
                card_label.set('card_name', self.model.get('name'));
                var labels = data.name.split(',');
                var view_label = self.$el.find('.js-card-labels-list');
                self.$el.find('.js-card-label-show').remove();
                self.model.labels.reset();
                if (!_.isUndefined(response.cards_labels)) {
                    labels = response.cards_labels;
                }
                if (labels.length > 0) {
                    _.each(labels, function(label) {
                        var new_label = new App.Label();
                        new_label.set(label);
                        if (!_.isUndefined(label.id)) {
                            new_label.set('id', parseInt(label.id));
                            new_label.set('label_id', parseInt(label.label_id));
                        } else {
                            new_label.set('name', label);
                        }
                        new_label.set('board_id', self.model.attributes.board_id);
                        new_label.set('list_id', self.model.attributes.list_id);
                        new_label.set('card_id', self.model.id);
                        self.model.list.collection.board.labels.add(new_label, {
                            silent: true
                        });
                        self.model.labels.add(new_label);
                        var view = new App.CardLabelView({
                            model: new_label,
                            background: self.getLabelcolor('' + new_label.attributes.name).substring(0, 6)
                        });
                        view_label.prepend(view.render().el);
                        $('#js-card-' + self.model.id).addClass('active');
                        $('.js-label-dropdown').removeClass('open');
                    });
                } else {
                    $('.js-card-label-section-' + self.model.id).html("");
                }
                if (!_.isUndefined(response.activity) && response.activity !== false) {
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board,
                        flag: '1'
                    });
                    self.model.activities.unshift(activity);
                    if ($.cookie('filter') !== 'comment') {
                        var view_activity = $('#js-card-activities-' + self.model.id);
                        view_activity.prepend(view.render().el);
                    }
                    emojify.run();
                }
            }
        });
        return false;
    },
    /**
     * showCardLabelForm()
     * show card label add form
     * @param e
     * @type Object(DOM event)
     */
    showCardLabelForm: function(e) {
        var self = this;
        var doc = $('#js-card-modal-' + this.model.id);
        var slected_labels = new App.CardLabelCollection();
        var labels = '';
        var card_labels = this.model.list.collection.board.labels.where({
            card_id: this.model.id
        });
        this.model.labels.add(card_labels, {
            silent: true
        });
        this.model.labels.each(function(label) {
            if (_.escape(label.attributes.name) !== "") {
                labels += _.escape(label.attributes.name) + ',';
            }
        });
        labels = labels.substr(0, labels.length - 1);
        $('.js-show-card-label-form-response').html(new App.CardLabelFormView({
            model: labels,
            card: this.model
        }).el);
        $('.inputCardLabel', doc).select2({
            formatSelection: this.repoFormatResult,
            tags: _.uniq(self.model.list.collection.board.labels.pluck('name')),
            tokenSeparators: [',', ' '],
            dropdownParent: '.dockmodal'
        });
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        if (target.hasClass('js-card-header-action')) {
            return false;
        }
    },
    repoFormatResult: function(label) {
        var current_label = self.model.labels.findWhere({
            'name': label.id
        });
        if (current_label) {
            return '<span data-color="' + current_label.attributes.color + '" data-label="' + label.id + '">' + label.id + '</span>';
        }
        return label.id;
    },
    /**
     * showCardDueDateForm()
     * display card due date form
     * @param e
     * @type Object(DOM event)
     */
    showCardDueDateForm: function(e) {
        var self = this;
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        return false;
    },
    /**
     * cancelCardDescEditForm()
     * hide card description edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    cancelCardDescEditForm: function(e) {
        this.$el.find('.js-show-card-desc').show();
        this.$el.find('#cardDescriptionEditForm').addClass('hide');
        return false;
    },
    showMemberSearchKeyDown: function(e) {
        var position = $(e.target).getCursorPosition();
        var deleted = '';
        var val = $(e.target).val();
        if (e.which == 8) {
            if (position[0] == position[1]) {
                if (position[0] === 0)
                    deleted = '';
                else
                    deleted = val.substr(position[0] - 1, 1);
            } else {
                deleted = val.substring(position[0], position[1]);
            }
        } else if (e.which == 46) {
            val = $(e.target).val();
            if (position[0] == position[1]) {
                if (position[0] === val.length)
                    deleted = '';
                else
                    deleted = val.substr(position[0], 1);
            } else {
                deleted = val.substring(position[0], position[1]);
            }
        }
        this.deletedKey = deleted;
    },
    /**
     * showMemberSearch()
     * Show member search form and search members
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    showMemberSearch: function(e) {
        var target = $(e.target);
        var open = false;
        if (e.key == "Shift") {
            this.prevKey = e.key;
        } else if (e.key == "2" && this.prevKey == "Shift") {
            open = true;
        } else {
            this.prevKey = '';
        }
        $(".js-comment").removeClass("current-comment-box");
        $(e.target).addClass("current-comment-box");
        var q = $(e.target).val();
        var keyCode = e.which || e.keyCode;
        if (e.key == '@' || open) {
            this.autoMentionSelectionStart = e.target.selectionStart;
            if ($(target).parents('#AddActivityForm').length > 0) {
                $(target).parents('#AddActivityForm').find('.js-show-members').parents('.dropdown:first').addClass('open');
            } else {
                $(target).parents('.comment-block').find('.js-show-members').parents('.dropdown:first').addClass('open');
            }
        } else if (this.autoMentionSelectionStart) {
            if (keyCode == 32) {
                this.autoMentionSelectionStart = 0;
                if ($(target).parents('#AddActivityForm').length > 0) {
                    $(target).parents('#AddActivityForm').find('.js-show-members').parents('.dropdown:first').removeClass('open');
                } else {
                    $(target).parents('.comment-block').find('.js-show-members').parents('.dropdown:first').removeClass('open');
                }
            } else {
                var regex = /\s/gi,
                    result, indice;
                while ((result = regex.exec(q))) {
                    if (result.index >= this.autoMentionSelectionStart) {
                        indice = result.index;
                        break;
                    }
                }
                if (!indice) {
                    indice = q.length;
                }
                var text = q.substr(this.autoMentionSelectionStart, (indice) - this.autoMentionSelectionStart);
                var data = text.split(" ");
                $('.js-search-member').val(data[0]).trigger('keyup');
            }
        }
        if (this.deletedKey === '@' || q === '' || e.key == 'Space') {
            this.autoMentionSelectionStart = 0;
            if ($(target).parents('#AddActivityForm').length > 0) {
                $(target).parents('#AddActivityForm').find('.js-show-members').parents('.dropdown:first').removeClass('open');
            } else {
                $(target).parents('.comment-block').find('.js-show-members').parents('.dropdown:first').removeClass('open');
            }
        }
        return false;
    },
    /**
     * showCardDescEditForm()
     * display card description edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    showCardDescEditForm: function(e) {
        e.preventDefault();
        this.$el.find('.js-show-card-desc').hide();
        this.$el.find('#cardDescriptionEditForm').removeClass('hide').show();
        return false;
    },
    showCardDesc: function(e) {
        e.preventDefault();
        var cardId = $(e.currentTarget).attr("data-id");
        if (!$('.show-description-' + cardId).hasClass('active')) {
            $('.show-description-' + cardId).addClass('active');
            $('.preview-description-' + cardId).removeClass('active');
        }
        this.$el.find('textarea#inputCarddescriptions').removeClass('hide').addClass('show');
        this.$el.find('.js-card-desc-edit-panel').addClass('hide');
    },
    previewCardDesc: function(e) {
        e.preventDefault();
        var cardId = $(e.currentTarget).attr("data-id");
        $('.show-description-' + cardId).removeClass('active');
        $('.preview-description-' + cardId).addClass('active');
        if (this.$el.find('textarea#inputCarddescriptions').hasClass('show')) {
            this.$el.find('textarea#inputCarddescriptions').removeClass('show').addClass('hide');
        } else {
            this.$el.find('textarea#inputCarddescriptions').addClass('hide');
        }
        var value = this.$el.find('textarea#inputCarddescriptions').val();
        if (value !== "") {
            this.$el.find('.js-card-desc-edit-preview').html(this.converter.makeHtml(value));
        } else {
            this.$el.find('.js-card-desc-edit-preview').html("<p>Nothing to preview</p>");
        }
        this.$el.find('.js-card-desc-edit-panel').removeClass('hide').show();
    },
    /**
     * editCard()
     * update card
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editCard: function(e) {
        e.preventDefault();
        var self = this;
        var validation = true;
        var data = $(e.target).serializeObject();
        var edit_mode = $(e.target).closest('form').find('#inputCarddescriptions').data('edit_mode');
        if (edit_mode === 1 && $.trim(data.name) === '') {
            $('.error-msg-name').remove();
            $('<div class="error-msg-name text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputCardName');
            return false;
        }
        if (!_.isUndefined(data.due_date) || !_.isUndefined(data.due_time)) {
            data = {
                to_date: data.due_date,
                due_date: data.due_date + ' ' + data.due_time,
                start: data.due_date + 'T' + data.due_time
            };
        }
        if (!_.isUndefined(data.start_date) || !_.isUndefined(data.start_time)) {
            data = {
                to_date: data.start_date,
                start_date: data.start_date + ' ' + data.start_time,
                start: data.start_date + 'T' + data.start_time
            };
        }
        this.model.set(data);
        var target = $(e.currentTarget);
        $('.js-show-side-card-title-edit-form').parents().find('.dropdown').removeClass('open');
        if (!_.isUndefined(data.name)) {
            target.prev('h4').html(_.escape(data.name)).removeClass('hide');
        }
        if (!_.isUndefined(data.description) && !_.isEmpty(data.description)) {
            if (!$.trim($('#inputCarddescriptions').val()).length) {
                $('.error-msg').remove();
                $('<div class="error-msg text-primary h6">Whitespace is not allowed</div>').insertAfter('#inputCarddescriptions');
                validation = false;
                this.$el.find('#cardDescriptionEditForm').removeClass('hide').show();
            } else {
                $('.error-msg').remove();
                $('.js-show-card-desc').next().show();
                $('#cardDescriptionEditForm').hide();
                validation = true;
            }
        }
        if (validation) {
            this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '.json';
            this.model.save(data, {
                patch: true,
                success: function(model, response, options) {
                    if (_.isUndefined(options.temp_id)) {
                        self.model.set('is_offline', false);
                    } else {
                        this.model.set('is_offline', true);
                    }
                    if (!_.isEmpty(response)) {
                        if (!_.isUndefined(response.activity)) {
                            var activity = new App.Activity();
                            activity.set(response.activity);
                            activity.board_users = self.model.board_users;
                            var view = new App.ActivityView({
                                model: activity,
                                board: self.model.list.collection.board,
                                flag: '1'
                            });
                            self.model.activities.unshift(activity, {
                                silent: true
                            });
                            if ($.cookie('filter') !== 'comment') {
                                var view_activity = $('#js-card-activities-' + self.model.id);
                                view_activity.prepend(view.render().el);
                            }
                            emojify.run();
                        }
                        self.model.cards.add(self.model);
                    }
                    if (!_.isEmpty(data.due_date)) {
                        if (!_.isEmpty(response.child_cards) && !_.isUndefined(response.child_cards)) {
                            $('main').trigger('dueDateRendered', response.child_cards);
                        }
                        self.model.list.collection.board.lists.each(function(list) {
                            var cards = list.get('cards') || [];
                            if (!_.isEmpty(cards)) {
                                _.each(cards, function(card) {
                                    if (card.id === self.model.id) {
                                        card.due_date = data.due_date;
                                    }
                                });
                            }
                        });
                        self.model.set('due_date', data.start);
                        self.model.set('title', response.activity.card_name);
                    }
                    if (!_.isEmpty(data.start_date)) {
                        self.model.list.collection.board.lists.each(function(list) {
                            var cards = list.get('cards') || [];
                            if (!_.isEmpty(cards)) {
                                _.each(cards, function(card) {
                                    if (card.id === self.model.id) {
                                        card.start_date = data.start_date;
                                    }
                                });
                            }
                        });
                        self.model.set('start_date', data.start);
                        self.model.set('title', response.activity.card_name);
                    }
                }
            });
        }
        return false;
    },
    /**
     * cancelCardTitleEditForm()
     * hide card title edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    cancelCardTitleEditForm: function(e) {
        var target = $(e.currentTarget);
        target.parents('form').addClass('hide');
        target.parents('form').prev('h4').removeClass('hide');
        return false;
    },
    /**
     * showCardTitleEditForm()
     * display card title edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    showCardTitleEditForm: function(e) {
        var target = $(e.currentTarget);
        target.parent('h4').addClass('hide');
        $('form#cardTitleEditForm').removeClass('hide');
        return false;
    },
    /**
     * show()
     * display card details in docmodal
     */
    show: function() {
        $('#js-card-' + this.model.id).addClass('active');
        $('#js-card-modal-' + this.model.id).find('.js-load-more-block').remove();
        this.render();
        var self = this;
        self.model.activities = new App.ActivityCollection();
        var filter = $.cookie('filter');
        if (filter === undefined || filter === 'all') {
            filter = 'all';
        } else if (filter === 'comment') {
            filter = 'comment';
        } else if (filter === 'activity') {
            filter = 'activity';
        }
        self.model.activities.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/activities.json?mode=' + filter + '&page=0';
        self.model.activities.fetch({
            cache: false,
            success: function(model, response) {
                self.model.set('activity_count', response._metadata.total_records);
                self.renderActivitiesCollection();
            }
        });
    },
    /**
     * CloseDragDrop()
     * close drag and drop attachment view
     */
    CloseDragDrop: function() {
        $('#js-card-modal-' + this.model.id).removeClass('drophover');
        $('#js-card-modal-' + this.model.id).find('#js-close-drag').addClass('hide');
    },
    /**
     * refreshdock()
     * update dock modal view
     */
    refreshdock: function() {
        var doc = $('#js-card-modal-' + this.model.id);
        var self = this;
        if (doc.length !== 0) {
            var cards_subscribers = this.model.cards_subscribers.where({
                is_subscribed: 1,
                user_id: parseInt(authuser.user.id)
            });
            var subscribed = '';
            if (!_.isEmpty(cards_subscribers)) {
                subscribed = ' <span class="icon-eye-open"></span>';
            }
            var class_name = '';
            var text = i18next.t('%s in list %s %s', {
                postProcess: 'sprintf',
                sprintf: [_.escape(this.model.attributes.name), _.escape(this.model.list.attributes.name), subscribed]
            });
            if (parseInt(this.model.attributes.is_archived) === 1) {
                class_name = ' label label-warning';
                text = i18next.t('This card is archived.');
            }
            $('.title-text', doc.parent().prev('.dockmodal-header')).html('<div class="card-id inline-show"><strong>#' + this.model.id + '</strong></div><span class="title-color' + class_name + '" id="js-title-color-' + this.model.id + '">' + text + '</span>');
            var comment = this.$el.find('#inputAddComment').val();
            var description = this.$el.find('#inputCarddescriptions').val();
            var checklistEditName = this.$el.find('#checklistEditName').val();
            var ChecklistItem = this.$el.find('#ChecklistItem').val();
            doc.html(this.template({
                card: this.model,
                checklist_lists: this.checklist_list,
                converter: this.converter,
                list: this.model.list,
                DROPBOX_APPKEY: this.DROPBOX_APPKEY
            })).dockmodal('refreshLayout');
            self.$el.find('.js-modal-settings').removeClass('hide');
            _(function() {
                Backbone.TemplateManager.baseUrl = '{name}';
                var uploadManager = new Backbone.UploadManager({
                    uploadUrl: api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/attachments.json?token=' + api_token,
                    autoUpload: true,
                    singleFileUploads: false,
                    formData: $('form.js-user-profile-edit').serialize(),
                    dropZone: $('#dropzone' + self.model.id),
                    pasteZone: $('#dropzone' + self.model.id)
                });
                var loader_id = '';
                uploadManager.on('fileadd', function(file) {
                    if (!file.attributes.data.name) {
                        var currentdate = new Date();
                        file.attributes.data.name = 'upload_' + (currentdate.getMonth() + 1) + '_' + currentdate.getDate() + '_' + currentdate.getFullYear() + '_at_' + ((currentdate.getHours() + 11) % 12 + 1) + '_' + currentdate.getMinutes() + '_' + currentdate.getSeconds() + '_' + ((currentdate.getHours() >= 12) ? 'PM' : 'AM') + '.' + file.attributes.data.type.split('/')[1];
                    }
                    loader_id = new Date().getTime();
                    $('#js-card-modal-' + self.model.id).parent('.dockmodal-body').prev('.dockmodal-header').find('.cssloader').remove();
                    $('#js-card-modal-' + self.model.id).parent('.dockmodal-body').prev('.dockmodal-header').append('<span id="' + loader_id + '" class="cssloader"></span>');
                    self.$('.js_card_image_upload').addClass('cssloader');
                });
                uploadManager.on('fileuploaddragover', function(e) {
                    $('#js-card-modal-' + self.model.id).addClass('drophover');
                    $('#js-card-modal-' + self.model.id).find('#js-close-drag').removeClass('hide');
                });
                var dragging = 0;
                $('#dropzone' + self.model.id).on('dragenter', function(e) {
                    dragging++;

                });
                $('#dropzone' + self.model.id).on('dragleave', function(e) {
                    dragging--;
                    if (dragging === 0) {
                        $('#js-card-modal-' + self.model.id).find('#js-close-drag').addClass('hide');
                        $('#js-card-modal-' + self.model.id).removeClass('drophover');
                    }
                });
                uploadManager.on('fileuploaddrop', function(e) {
                    dragging--;
                    $('#js-card-modal-' + self.model.id).find('#js-close-drag').addClass('hide');
                    $('#js-card-modal-' + self.model.id).removeClass('drophover');
                });
                uploadManager.on('filedone', function(file, data) {
                    $('#js-card-modal-' + self.model.id).parent('.dockmodal-body').prev('.dockmodal-header').find('.cssloader').remove();
                    var response = {};
                    response = data.result;
                    var card_attachments = new App.CardAttachmentCollection();
                    var i = 1;
                    card_attachments.add(response.card_attachments);
                    card_attachments.each(function(attachment) {
                        var options = {
                            silent: true
                        };
                        if (i === card_attachments.models.length) {
                            options.silent = false;
                        }
                        attachment.set('id', parseInt(attachment.attributes.id));
                        attachment.set('board_id', parseInt(attachment.attributes.board_id));
                        attachment.set('list_id', parseInt(attachment.attributes.list_id));
                        attachment.set('card_id', parseInt(attachment.attributes.card_id));
                        self.model.attachments.unshift(attachment, options);
                        self.model.list.collection.board.attachments.unshift(attachment, {
                            silent: true
                        });
                        i++;
                    });
                });
                $('body').trigger('modalCardRendered', self.model.id, self.model);
            }).defer();
            this.$el.find('#inputAddComment').val(comment).focus();
            this.$el.find('#inputCarddescriptions').val(description).focus();
            this.$el.find('#checklistEditName').val(checklistEditName).focus();
            this.$el.find('#ChecklistItem').val(ChecklistItem).focus();
            this.resizeSplitter();
            this.renderAttachmentsCollection();
            this.renderLabelsCollection();
            this.renderUsersCollection();
            this.model.activities = new App.ActivityCollection();
            var filter = $.cookie('filter');
            if (filter === undefined || filter === 'all') {
                filter = 'all';
            } else if (filter === 'comment') {
                filter = 'comment';
            } else if (filter === 'activity') {
                filter = 'activity';
            }
            this.model.activities.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/activities.json?mode=' + filter + '&page=0';
            this.model.activities.fetch({
                cache: false,
                success: function(model, response) {
                    self.model.set('activity_count', response._metadata.total_records);
                    self.renderActivitiesCollection();
                }
            });
            this.renderChecklistsCollection();
            $('.js-card-duedate-edit-' + self.model.id).datetimepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: 'top-right',
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                bootcssVer: 2,
                pickTime: false
            }).on('changeDate', function(ev) {
                $(this).datetimepicker('hide');
                $(this).blur();
            });
            $('.js-card-duetime-edit-' + self.model.id).datetimepicker({
                format: 'hh:ii',
                autoclose: true,
                showMeridian: false,
                pickerPosition: 'top-right',
                startView: 1,
                maxView: 1,
                pickDate: false,
                use24hours: true,
                timepicker: 1,
            }).on('changeDate', function(ev) {
                $(this).datetimepicker('hide');
                $(this).blur();
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
    render: function() {
        this.converter.setFlavor('github');
        var self = this;
        var subscribed = '';
        if (!_.isUndefined(authuser.user)) {
            var cards_subscribers = this.model.cards_subscribers.where({
                is_subscribed: 1,
                user_id: parseInt(authuser.user.id)
            });
            if (!_.isEmpty(cards_subscribers)) {
                subscribed = ' <span class="icon-eye-open"></span>';
            }
        }
        if (this.initialState) {
            initialState = this.initialState;
        } else if (trigger_dockmodal) {
            initialState = 'minimized';
        }
        var doc = $('#js-card-modal-' + this.model.id);
        localforage.getItem('unreaded_cards', function(err, value) {
            if (value && value[self.model.attributes.id]) {
                var removeItem = 'js-card-' + self.model.attributes.id;
                $('#' + removeItem).find('.js-unread-notification').remove();
                value.splice(self.model.attributes.id, 1);
                localforage.setItem("unreaded_cards", value);
            }
        });
        if (doc.length === 0) {
            $('.js-hidden-blocks').append(this.$el.html(this.template({
                card: this.model,
                checklist_lists: this.checklist_list,
                converter: this.converter,
                list: this.model.list,
                DROPBOX_APPKEY: this.DROPBOX_APPKEY
            })).attr('id', 'js-card-modal-' + this.model.id));
            this.renderAttachmentsCollection();
            this.renderLabelsCollection();
            this.renderUsersCollection();
            this.renderChecklistsCollection();
            var title = i18next.t('%s in list %s %s', {
                postProcess: 'sprintf',
                sprintf: [_.escape(this.model.attributes.name), _.escape(this.model.list.attributes.name), subscribed]
            });
            var is_modalCard_close = false;
            var class_name = '';
            if (parseInt(this.model.attributes.is_archived) === 1) {
                class_name = ' label label-warning';
                title = i18next.t('This card is archived.');
            }
            this.$el.dockmodal({
                initialState: initialState,
                height: 450,
                width: 600,
                animationSpeed: ANIMATION_SPEED,
                title: '<div class="card-id inline-show"><strong>#' + this.model.id + '</strong></div><span class="title-color' + class_name + '" id="js-title-color-' + this.model.id + '">' + title + '</span>',
                beforePopout: function(event) {
                    if (!_.isUndefined(authuser.user)) {
                        $('#js-title-color-' + self.model.id).parent('.title-text').css('margin-left', '34px');
                    }
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
                    if (!_.isUndefined(authuser.user)) {
                        $('#js-title-color-' + self.model.id).parent('.title-text').css('margin-left', '34px');
                    }
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
                beforeMinimize: function(event) {
                    $('#js-title-color-' + self.model.id).parent('.title-text').removeAttr('style');
                },
                minimize: function(event) {
                    $('#js-title-color-' + self.model.id).parent('.title-text').removeAttr('style');
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
                    self.$el.find('.js-modal-settings').removeClass('hide');
                },
                beforeClose: function(event, dialog) {
                    var description;
                    var comment = $('#js-card-modal-' + self.model.id).find('#inputAddComment').val();
                    if ($('#js-card-modal-' + self.model.id).find('#cardDescriptionEditForm').hasClass('hide')) {
                        description = '';
                    } else {
                        description = $('#js-card-modal-' + self.model.id).find('#inputCarddescriptions').val();
                    }
                    if (!_.isEmpty(comment) || !_.isEmpty(description)) {
                        if (window.confirm(i18next.t('You have unsaved changes on this card. Do you want to close this card and discard your changes or stay on this card?'))) {
                            is_modalCard_close = true;
                        } else {
                            return false;
                        }
                    } else {
                        is_modalCard_close = true;
                    }
                },
                close: function(event, dialog) {
                    if (is_modalCard_close) {
                        $('#js-card-' + self.model.id).removeClass('active');
                        var current_param = Backbone.history.fragment;
                        if (current_param.indexOf('board/') != -1) {
                            card_ids_ref = _.without(card_ids_ref, self.model.id);
                            if (current_param.indexOf(',' + self.model.id) != -1) {
                                current_param = current_param.replace(',' + self.model.id, '');
                            } else if (current_param.indexOf(self.model.id + ',') != -1) {
                                current_param = current_param.replace(self.model.id + ',', '');
                            } else if (current_param.indexOf('/card/' + self.model.id) != -1) {
                                current_param = current_param.replace('/card/' + self.model.id, '');
                                changeTitle('Board - ' + _.escape(App.current_board.attributes.name));
                            } else {
                                var board_id = window.location.hash.split("/");
                                current_param = 'board/' + board_id['2'];
                                changeTitle('Board - ' + _.escape(App.current_board.attributes.name));
                            }
                            app.navigate('#/' + current_param, {
                                trigger: false,
                                trigger_function: false,
                            });
                            event.remove();
                        }
                        self.model.unbind('change:list_id');
                    }
                }
            });
            $('.js-card-duedate-edit-' + self.model.id).datetimepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: 'top-right',
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                bootcssVer: 2,
                pickTime: false
            }).on('changeDate', function(ev) {
                $(this).datetimepicker('hide');
                $(this).blur();
            });
            $('.js-card-duetime-edit-' + self.model.id).datetimepicker({
                format: 'hh:ii',
                autoclose: true,
                showMeridian: false,
                pickerPosition: 'top-right',
                startView: 1,
                maxView: 1,
                pickDate: false,
                use24hours: true,
                timepicker: 1,
            }).on('changeDate', function(ev) {
                $(this).datetimepicker('hide');
                $(this).blur();
            });
        } else {
            doc.dockmodal('restore');
        }
        this.$el.find('.js-organization-member-search-response').html('');
        this.$el.find('.js-comment-member-search-response').nextAll().remove();
        _(function() {
            Backbone.TemplateManager.baseUrl = '{name}';
            var uploadManager = new Backbone.UploadManager({
                uploadUrl: api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/attachments.json?token=' + api_token,
                autoUpload: true,
                singleFileUploads: false,
                formData: $('form.js-user-profile-edit').serialize(),
                dropZone: $('#dropzone' + self.model.id),
                pasteZone: $('#dropzone' + self.model.id)
            });
            var loader_id = '';
            uploadManager.on('fileadd', function(file) {
                if (!file.attributes.data.name) {
                    var currentdate = new Date();
                    file.attributes.data.name = 'upload_' + (currentdate.getMonth() + 1) + '_' + currentdate.getDate() + '_' + currentdate.getFullYear() + '_at_' + ((currentdate.getHours() + 11) % 12 + 1) + '_' + currentdate.getMinutes() + '_' + currentdate.getSeconds() + '_' + ((currentdate.getHours() >= 12) ? 'PM' : 'AM') + '.' + file.attributes.data.type.split('/')[1];
                }
                loader_id = new Date().getTime();
                $('.js-attachment-loader', $('#js-card-modal-' + self.model.id)).html('<div class="navbar-btn dockheader-loader"><span class="cssloader"></span></div>');
                self.$('.js_card_image_upload').addClass('cssloader');
            });
            uploadManager.on('fileuploaddragover', function(e) {
                $('#js-card-modal-' + self.model.id).addClass('drophover');
                $('#js-card-modal-' + self.model.id).find('#js-close-drag').removeClass('hide');
            });
            var dragging = 0;
            $('#dropzone' + self.model.id).on('dragenter', function(e) {
                dragging++;
            });
            $('#dropzone' + self.model.id).on('dragleave', function(e) {
                dragging--;
                if (dragging === 0) {
                    $('#js-card-modal-' + self.model.id).find('#js-close-drag').addClass('hide');
                    $('#js-card-modal-' + self.model.id).removeClass('drophover');
                }
            });
            uploadManager.on('fileuploaddrop', function(e) {
                dragging--;
                $('#js-card-modal-' + self.model.id).find('#js-close-drag').addClass('hide');
                $('#js-card-modal-' + self.model.id).removeClass('drophover');
            });
            uploadManager.on('filedone', function(file, data) {
                $('#js-card-modal-' + self.model.id).parent('.dockmodal-body').prev('.dockmodal-header').find('.cssloader').remove();
                $('.js-attachment-loader', $('#js-card-modal-' + self.model.id)).html('');
                var response = {};
                response = data.result;
                var card_attachments = new App.CardAttachmentCollection();
                var i = 1;
                card_attachments.add(response.card_attachments);
                card_attachments.each(function(attachment) {
                    var options = {
                        silent: true
                    };
                    if (i === card_attachments.models.length) {
                        options.silent = false;
                    }
                    attachment.set('id', parseInt(attachment.attributes.id));
                    attachment.set('board_id', parseInt(attachment.attributes.board_id));
                    attachment.set('list_id', parseInt(attachment.attributes.list_id));
                    attachment.set('card_id', parseInt(attachment.attributes.card_id));
                    self.model.attachments.unshift(attachment, options);
                    self.model.list.collection.board.attachments.unshift(attachment, {
                        silent: true
                    });
                    i++;
                });
            });
            $('body').trigger('modalCardRendered', [self.model.id, self.model]);
        }).defer();
        if (!_.isUndefined(authuser.user)) {
            $('#js-card-checklists', this.$el).sortable({
                items: 'div.js-card-checklist',
                axis: 'y',
                placeholder: 'form-group card-list-placeholder col-xs-12',
                cursor: 'grab',
                scroll: true,
                helper: 'clone',
                handle: '.js-checklist-head',
                tolerance: 'pointer',
                update: function(ev, ui) {
                    ui.item.trigger('checklistSort', ev, ui);
                },
                start: function(ev, ui) {
                    ui.placeholder.height(ui.item.outerHeight());
                    $(ev.target).find('.js-checklist-head').removeClass('cur-grab');
                },
                stop: function(ev, ui) {
                    $(ev.target).find('.js-checklist-head').addClass('cur-grab');
                }
            });
        }
        this.resizeSplitter();
        this.showTooltip();
        return this;
    },
    resizeSplitter: function() {
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
    /**
     * closePopup()
     * hide opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        var activity_id = $(e.currentTarget).data('activity-id');
        $('.js-acticity-action-' + activity_id).removeAttr('style');
        target.parents('.dropdown:first').removeClass('open');
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
        target.addClass('open').prev('.dropdown').removeClass('open');
        target.next('.dropdown').removeClass('open');
        return false;
    },
    /**
     * addCardVote()
     * add vote for card
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    addCardVote: function(e, ui) {
        var self = this;
        var card_id = this.model.id;
        var list_id = this.model.attributes.list_id;
        var board_id = this.model.attributes.board_id;
        var uuid = new Date().getTime();
        var cardVoter = this.model.card_voters.findWhere({
            'user_id': parseInt(authuser.user.id),
            'card_id': card_id
        });
        if (_.isUndefined(cardVoter)) {
            $(e.currentTarget).removeClass('js-add-card-vote');
            $('.panel-title', e.currentTarget).html('<i class="icon-thumbs-up-alt"></i> ' + i18next.t('Unvote'));
            var card_voter = new App.CardVoter();
            card_voter.set('is_offline', true);
            card_voter.set('card_id', parseInt(card_id));
            card_voter.set('user_id', parseInt(authuser.user.id));
            card_voter.set('board_id', board_id);
            card_voter.set('list_id', list_id);
            card_voter.set('username', authuser.user.username);
            card_voter.set('role_id', authuser.user.role_id);
            card_voter.set('profile_picture_path', authuser.user.profile_picture_path);
            card_voter.set('initials', authuser.user.initials);
            var vote_count = self.model.attributes.card_voter_count;
            if (_.isUndefined(vote_count)) {
                vote_count = 0;
            }
            self.model.card_voters.add(card_voter);
            self.model.set('card_voter_count', parseInt(vote_count) + 1);
            self.model.list.collection.board.cards.get(self.model.id).card_voters.add(card_voter);
            card_voter.url = api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards/' + card_id + '/card_voters.json';
            card_voter.save({}, {
                success: function(model, response, options) {
                    if (_.isUndefined(options.temp_id)) {
                        card_voter.set('is_offline', false);
                    }
                    if (!_.isUndefined(response.id) && _.isUndefined(options.temp_id)) {
                        card_voter.set({
                            id: parseInt(response.id)
                        });
                    } else {
                        global_uuid[uuid] = options.temp_id;
                        card_voter.set('id', uuid);
                    }
                    if (!_.isUndefined(response.id)) {
                        self.model.card_voters.findWhere({
                            card_id: card_id,
                            user_id: parseInt(authuser.user.id)
                        }).set('id', parseInt(response.id));
                        $(e.currentTarget).addClass('js-delete-card-vote').data('id', response.id);
                    }
                    //self.model.list.collection.board.cards.get(self.model.id).card_voters.add(card_voter);
                    if (!_.isUndefined(response.activity)) {
                        var activity = new App.Activity();
                        activity.set(response.activity);
                        activity.board_users = self.model.board_users;
                        var view = new App.ActivityView({
                            model: activity,
                            board: self.model.list.collection.board,
                            flag: '1'
                        });
                        self.model.activities.unshift(activity);
                        if ($.cookie('filter') !== 'comment') {
                            var view_activity = $('#js-card-activities-' + self.model.id);
                            view_activity.prepend(view.render().el);
                        }
                        emojify.run();
                    }
                }
            });
        } else {
            if (!$(e.currentTarget).hasClass('js-delete-card-vote')) {
                $(e.currentTarget).addClass('js-delete-card-vote');
            }
            $('.js-delete-card-vote', e.target).trigger('click');
        }
        return false;
    },
    /**
     * deleteCardVote()
     * unvote card
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    deleteCardVote: function(e, ui) {
        var self = this;
        var card_id = this.model.id;
        var list_id = this.model.attributes.list_id;
        var board_id = this.model.attributes.board_id;
        var voted_user = this.model.card_voters.findWhere({
            card_id: card_id,
            user_id: parseInt(authuser.user.id)
        });
        var voter_id = voted_user.id;
        $(e.currentTarget).removeClass('js-delete-card-vote').addClass('js-add-card-vote');
        $('.panel-title', e.currentTarget).html('<i class="icon-thumbs-up-alt"></i> ' + i18next.t('Vote'));

        $('i.icon-ok', e.currentTarget).remove();
        var card_voter = new App.CardVoter();
        card_voter.set('id', voter_id);
        this.model.card_voters.remove(card_voter);
        this.model.list.collection.board.cards.get(self.model.id).card_voters.remove(card_voter);
        card_voter.url = api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards/' + card_id + '/card_voters/' + voter_id + '.json';
        self.model.card_voters.remove(card_voter);
        var vote_count = self.model.attributes.card_voter_count;
        self.model.set('card_voter_count', parseInt(vote_count) - 1);
        card_voter.destroy({
            success: function(model, response) {
                if (!_.isUndefined(response.activity)) {
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board,
                        flag: '1'
                    });
                    self.model.activities.unshift(activity);
                    if ($.cookie('filter') !== 'comment') {
                        var view_activity = $('#js-card-activities-' + self.model.id);
                        view_activity.prepend(view.render().el);
                    }
                    emojify.run();
                }
            }
        });
        return false;
    },
    /**
     * cardSubscribe()
     * subscribe card
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    cardSubscribe: function(e) {
        var card_id = this.model.id;
        var list_id = this.model.attributes.list_id;
        var board_id = this.model.attributes.board_id;
        var card_subscribe_id = 'undefined';
        var self = this;
        var uuid = new Date().getTime();
        $(e.currentTarget).removeClass('js-card-subscribe').addClass('js-card-unsubscribe');
        $('.js-subscribe-change-icon').append('<i class="icon-ok"></i>');
        $('.js-card-subscribed-' + card_id).removeClass('hide');
        var card_subscribe = new App.CardSubscriber();
        card_subscribe.set('is_offline', true);
        card_subscribe.set('card_id', card_id);
        card_subscribe.set('board_id', board_id);
        card_subscribe.set('list_id', list_id);
        card_subscribe.set('user_id', parseInt(authuser.user.id));
        card_subscribe.set('is_subscribed', 1);
        self.model.cards_subscribers.add(card_subscribe);
        if (typeof card_subscribe_id == 'undefined' || card_subscribe_id == 'undefined') {
            var subscribe = {
                subscribe: {
                    is_subscribed: 1
                }
            };
            card_subscribe.url = api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards/' + card_id + '/card_subscribers.json';
        } else {
            card_subscribe.id = parseInt(subscribe_id);
            card_subscribe.url = api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards/' + card_id + '/card_subscribers/' + subscribe_id + '.json';
        }
        card_subscribe.save({
            is_subscribed: 1
        }, {
            success: function(model, response, options) {
                if (_.isUndefined(options.temp_id) && !_.isEmpty(self.model.cards_subscribers) && !_.isUndefined(self.model.cards_subscribers) && self.model.cards_subscribers.length > 0) {
                    self.model.cards_subscribers.findWhere({
                        user_id: parseInt(authuser.user.id),
                        card_id: card_id
                    }).set('is_offline', false);
                }
                if (!_.isUndefined(self.model.cards_subscribers.findWhere({
                        user_id: parseInt(authuser.user.id),
                        card_id: card_id
                    }))) {
                    self.model.cards_subscribers.findWhere({
                        user_id: parseInt(authuser.user.id),
                        card_id: card_id
                    }).set('id', parseInt(response.id));
                    if (!_.isUndefined(response.id) && _.isUndefined(options.temp_id)) {
                        self.model.cards_subscribers.findWhere({
                            user_id: parseInt(authuser.user.id),
                            card_id: card_id
                        }).set('id', parseInt(response.id));
                    } else {
                        global_uuid[uuid] = options.temp_id;
                        self.model.cards_subscribers.findWhere({
                            user_id: parseInt(authuser.user.id),
                            card_id: card_id
                        }).set('id', uuid);
                    }
                }
            }
        });
        return false;
    },
    /**
     * cardUnsubscribe()
     * unsubscribe card
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    cardUnsubscribe: function(e) {
        $(e.currentTarget).removeClass('js-card-unsubscribe').addClass('js-card-subscribe');
        $('i.icon-ok', e.currentTarget).remove();
        var card_id = this.model.id;
        var list_id = this.model.attributes.list_id;
        var board_id = this.model.attributes.board_id;
        var self = this;
        var subscribe_id = 'undefined';
        var uuid = new Date().getTime();
        self.model.cards_subscribers.remove(self.model.cards_subscribers.findWhere({
            card_id: card_id,
            user_id: parseInt(authuser.user.id)
        }));
        $('.js-card-subscribed-' + card_id).addClass('hide');
        var card_subscribe = new App.CardSubscriber();
        card_subscribe.set('is_offline', true);
        if (typeof subscribe_id == 'undefined' || subscribe_id == 'undefined') {
            card_subscribe.url = api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards/' + card_id + '/card_subscribers.json';
        } else {
            card_subscribe.id = parseInt(subscribe_id);
            card_subscribe.url = api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards/' + card_id + '/card_subscribers/' + subscribe_id + '.json';
        }
        card_subscribe.save({
            is_subscribed: 0
        }, {
            success: function(model, response, options) {
                if (_.isUndefined(options.temp_id)) {
                    card_subscribe.set('is_offline', false);
                }
                if (!_.isUndefined(response.id) && _.isUndefined(options.temp_id)) {
                    card_subscribe.set({
                        id: parseInt(response.id)
                    });
                } else {
                    global_uuid[uuid] = options.temp_id;
                    card_subscribe.set('id', uuid);
                }
            }
        });
        return false;
    },
    /**
     * showMoveCardForm()
     * display card move form
     * @param e
     * @type Object(DOM event)
     */
    showMoveCardForm: function(e) {
        $('.js-show-move-card-form-response').html(new App.MoveCardView({
            model: this.model,
            boards: this.boards,
        }).el);
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        if (target.hasClass('js-card-header-action')) {
            return false;
        }
    },
    /**
     * moveCard()
     * update moved card move
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    moveCard: function(e) {
        e.preventDefault();
        var current_list_id = this.model.attributes.list_id;
        var current_board_id = this.model.attributes.board_id;
        var data = {};
        data = $(e.target).serializeObject();
        data.list_id = parseInt(data.list_id);
        data.board_id = parseInt(data.board_id);
        data.position = parseInt(data.position);

        var change_list = this.board.lists.findWhere({
            id: data.list_id
        });

        var change_list_cards = this.model.list.collection.board.cards.where({
            list_id: data.list_id
        });

        var change_list_cards_collection = new App.CardCollection();
        change_list_cards_collection.add(change_list_cards);
        var i = 1;
        var change_prev_card, change_next_card;
        change_list_cards_collection.each(function(card) {
            if (!card.attributes.is_archived && _.isUndefined(change_next_card)) {
                if (i === data.position) {
                    change_next_card = card;
                } else {
                    change_prev_card = card;
                }
                i++;
            }
        });
        if (!_.isUndefined(change_list)) {
            this.model.list = change_list;
        }
        if (change_list_cards.length === 0) {
            data.position = 1;
            this.model.set({
                position: data.position
            });
        } else {
            if (_.isUndefined(change_prev_card) && !_.isUndefined(change_next_card)) {
                data.position = (change_next_card.attributes.position) / 2;
                this.model.set({
                    position: data.position
                });
            } else if (_.isUndefined(change_next_card) && !_.isUndefined(change_next_card)) {
                data.position = (change_prev_card.attributes.position) + 1;
                this.model.set({
                    position: data.position
                });
            } else if (!_.isUndefined(change_prev_card)) {
                data.position = (change_prev_card.attributes.position + change_next_card.attributes.position) / 2;
                this.model.set({
                    position: data.position
                });
            } else {
                data.position = 1;
                this.model.set({
                    position: data.position
                });
            }
        }
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '.json';
        var self = this;
        this.model.save(data, {
            patch: true,
            success: function(model, response) {
                self.model.set('list_moved_date', response.activity.created);
                var list_moved_date_date_time = response.activity.created.split('T');
                list_moved_date_date_time = list_moved_date_date_time[0].split(' ');
                if ($('#js-card-' + self.model.id).find('.list-moved-date').length === 0) {
                    $('#js-card-' + self.model.id).find('.js-list-card-data').append('<li class="card-listing-truncate list-moved-date"><small title="' + i18next.t('List Moved Date') + '"><span class="label label-default">' + dateFormat(list_moved_date_date_time[0], 'mediumDate') + '</span></small></li>');
                } else {
                    $('#js-card-' + self.model.id).find('.list-moved-date').html('<small title="' + i18next.t('List Moved Date') + '"><span class="label label-default">' + dateFormat(list_moved_date_date_time[0], 'mediumDate') + '</span></small>');
                }
            }
        });
        if (data.list_id !== current_list_id) {
            this.model.list.collection.board.lists.get(current_list_id).cards.remove(this.model);
            if (data.board_id === current_board_id) {
                this.model.list.collection.board.lists.get(data.list_id).cards.add(this.model);
            }
            this.model.list = this.model.list.collection.get(data.list_id);
            var prev_list_card_count = parseInt(this.boards.get(current_board_id).lists.get(current_list_id).get('card_count'));
            this.boards.get(current_board_id).lists.get(current_list_id).set('card_count', prev_list_card_count - 1);
            var current_list = this.board.lists.findWhere({
                id: current_list_id
            });
            current_list.set('card_count', prev_list_card_count - 1);
            if (parseInt(current_list.attributes.card_count) === 0) {
                // Adding the &nbsp; to the current list if it has no card
                $('#js-card-listing-' + current_list.id).html('&nbsp;');
            }
            var change_list_card_count = parseInt(this.boards.get(data.board_id).lists.get(data.list_id).get('card_count'));
            this.boards.get(data.board_id).lists.get(data.list_id).set('card_count', change_list_card_count + 1);
            var changeList = this.boards.get(data.board_id).lists.get(data.list_id);
            _(function() {
                if ((current_list !== null && !_.isUndefined(current_list) && !_.isEmpty(current_list)) && (change_list !== null && !_.isUndefined(change_list) && !_.isEmpty(change_list))) {
                    if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_wip_limit', APPS.enabled_apps) !== -1) {
                        $('body').trigger('cardSortRendered', [current_list, changeList]);
                    }
                }
            }).defer();
            if (data.board_id === current_board_id) {
                change_list = this.board.lists.findWhere({
                    id: data.list_id
                });
                change_list.set('card_count', change_list_card_count + 1);
                if (parseInt(change_list.attributes.card_count) === 1) {
                    // Removing the &nbsp; from the new list in the same board
                    $('#js-card-listing-' + change_list.id).html(function(i, h) {
                        return h.replace(/&nbsp;/g, '');
                    });
                }
            }
        }
        return false;

    },
    /**
     * archiveCard()
     * save archived card
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    archiveCard: function(e) {
        var uuid = new Date().getTime();
        var self = this;
        this.model.set('is_offline', true);
        this.model.set('is_archived', 1);
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '.json';
        this.model.list.collection.board.cards.get(this.model.id).set('is_archived', 1);
        this.model.save({
            is_archived: 1
        }, {
            patch: true,
            success: function(model, response, options) {
                if (_.isUndefined(options.temp_id)) {
                    self.model.set('is_offline', false, {
                        silent: true
                    });
                }
                if (!_.isUndefined(self.model.id) && _.isUndefined(options.temp_id)) {
                    self.model.set({
                        id: parseInt(self.model.id)
                    }, {
                        silent: true
                    });
                } else {
                    global_uuid[uuid] = options.temp_id;
                    self.model.set('id', uuid, {
                        silent: true
                    });
                }
                var activity = new App.Activity();
                activity.set(response.activity, {
                    silent: true
                });
                activity.board_users = self.model.board_users;
                var list = App.boards.get(self.model.attributes.board_id).lists.get(self.model.attributes.list_id);
                if (!_.isUndefined(list)) {
                    list.set('card_count', list.attributes.card_count - 1, {
                        silent: true
                    });
                }
                var currentBoardList = App.current_board.lists.get(self.model.attributes.list_id);
                if (!_.isUndefined(currentBoardList)) {
                    currentBoardList.set('card_count', currentBoardList.attributes.card_count - 1, {
                        silent: true
                    });
                    if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_wip_limit', APPS.enabled_apps) !== -1) {
                        $('body').trigger('cardAddRendered', [currentBoardList.id, currentBoardList]);
                    }
                }
                if (parseInt(currentBoardList.attributes.card_count) === 0) {
                    // Adding the &nbsp; to the list if there is no card
                    $('#js-card-listing-' + self.model.attributes.list_id).html('&nbsp;');
                }
                var view = new App.ActivityView({
                    model: activity,
                    board: self.model.list.collection.board,
                    flag: '1'
                });
                model.set('activities', activity);
                if ($.cookie('filter') !== 'comment') {
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view.render().el);
                }
                emojify.run();
            }
        });
        self.$el.find('.js-modal-settings').removeClass('hide');
        return false;
    },
    /**
     * cardSendToBoard()
     * sent back to archived cards to board
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    cardSendToBoard: function(e) {
        var uuid = new Date().getTime();
        var self = this;
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '.json';
        this.model.set('is_offline', true);
        this.model.set('is_archived', 0);
        if (parseInt(this.model.list.attributes.card_count) === 0) {
            $('#js-card-listing-' + this.model.list.id).html(function(i, h) {
                return h.replace(/&nbsp;/g, '');
            });
        }
        this.model.save({
            is_archived: 0
        }, {
            patch: true,
            success: function(model, response, options) {
                if (_.isUndefined(options.temp_id)) {
                    self.model.set('is_offline', false, {
                        silent: true
                    });
                }
                if (!_.isUndefined(self.model.id) && _.isUndefined(options.temp_id)) {
                    self.model.set({
                        id: parseInt(self.model.id)
                    }, {
                        silent: true
                    });
                } else {
                    global_uuid[uuid] = options.temp_id;
                    self.model.set('id', uuid, {
                        silent: true
                    });
                }
                var activity = new App.Activity();
                activity.set(response.activity, {
                    silent: true
                });
                activity.board_users = self.model.board_users;
                var list = App.boards.get(self.model.attributes.board_id).lists.get(self.model.attributes.list_id);
                if (!_.isUndefined(list)) {
                    list.set('card_count', list.attributes.card_count + 1, {
                        silent: true
                    });
                }
                var currentBoardList = App.current_board.lists.get(self.model.attributes.list_id);
                if (!_.isUndefined(currentBoardList)) {
                    currentBoardList.set('card_count', currentBoardList.attributes.card_count + 1, {
                        silent: true
                    });
                    if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_wip_limit', APPS.enabled_apps) !== -1) {
                        $('body').trigger('cardAddRendered', [currentBoardList.id, currentBoardList]);
                    }
                }
                var view = new App.ActivityView({
                    model: activity,
                    board: self.model.list.collection.board,
                    flag: '1'
                });
                model.set('activities', activity);
                if ($.cookie('filter') !== 'comment') {
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view.render().el);
                }
                emojify.run();
            }
        });
        return false;
    },
    /**
     * deleteCard()
     * delete card
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    deleteCard: function(e) {
        var self = this;
        this.$el.modal('hide');
        var card_id = self.model.id;
        self.model.collection.remove(self.model);
        self.model.list.collection.board.cards.remove(self.model);
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + card_id + '.json';
        var doc = $('#js-card-modal-' + this.model.id);
        $('.action-close', doc.parent().prev('.dockmodal-header')).trigger('click');
        self.model.destroy({
            success: function(model, response) {
                var activity = new App.Activity();
                activity.set(response.activity);
                self.model.activities.unshift(activity);
                self.board.activities.unshift(response.activity);

            }
        });
        return false;
    },
    /**
     * computerOpen()
     * trigger file upload
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    computerOpen: function(e) {
        var fileLi = $(e.target);
        $('.js-card-attachment-form').remove();
        var form = $('<form class="js-card-attachment-form hide" enctype="multipart/form-data"></form">');
        $(form).append('<input type="hidden" name="card_id" value="' + this.model.id + '">');
        $(form).append('<input type="file" accept="' + ALLOWED_FILE_EXTENSIONS + '" name="attachment[]" class="js-card-attachment" multiple>');
        $(fileLi).after($(form));
        $('.js-card-attachment', form).trigger('click');
        return false;
    },
    /**
     * dropboxChooser()
     * image upload from dropbox
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    dropboxChooser: function(e) {
        var self = this;
        var attachmentUrl = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '/attachments.json?token=' + api_token;
        var options = {
            success: function(files) {
                $('.js-attachment-loader', $('#js-card-modal-' + self.model.id)).html('<div class="navbar-btn dockheader-loader"><span class="cssloader"></span></div>');
                self.$('.js_card_image_upload').addClass('cssloader');
                var image_link = [];
                _.map(files, function(file) {
                    image_link.push(file.link);
                });
                $.ajax({
                    type: 'POST',
                    url: attachmentUrl,
                    data: JSON.stringify({
                        card_id: self.model.id,
                        list_id: self.model.attributes.list_id,
                        board_id: self.model.attributes.board_id,
                        image_link: image_link
                    }),
                    success: function(response) {
                        if (is_offline_data) {
                            self.flash('danger', i18next.t('Sorry, attachment not added. Internet connection not available.'));
                        } else {
                            self.closePopup(e);
                            var card_attachments = new App.CardAttachmentCollection();
                            var i = 1;
                            card_attachments.add(response.card_attachments);
                            card_attachments.each(function(attachment) {
                                var options = {
                                    silent: true
                                };
                                if (i === card_attachments.models.length) {
                                    options.silent = false;
                                }
                                attachment.set('id', parseInt(attachment.attributes.id));
                                attachment.set('board_id', parseInt(attachment.attributes.board_id));
                                attachment.set('list_id', parseInt(attachment.attributes.list_id));
                                attachment.set('card_id', parseInt(attachment.attributes.card_id));
                                self.model.attachments.unshift(attachment, options);
                                self.model.list.collection.board.attachments.unshift(attachment, {
                                    silent: true
                                });
                                i++;
                            });
                            emojify.run();
                        }
                    },
                    contentType: 'application/json',
                    dataType: 'json'
                });
            },
            cancel: function() {},
            linkType: 'preview',
            multiselect: true
        };
        Dropbox.init({
            appKey: DROPBOX_APPKEY
        });
        Dropbox.choose(options);
        return false;
    },
    /**
     * addCardAttachment()
     * add card attachment
     * @param e
     * @type Object(DOM event)
     */
    addCardAttachment: function(e) {
        e.preventDefault();
        var self = this;
        $('.js-attachment-loader', $('#js-card-modal-' + self.model.id)).html('<div class="navbar-btn dockheader-loader"><span class="cssloader"></span></div>');
        self.$('.js_card_image_upload').addClass('cssloader');
        var form = $('form.js-card-attachment-form');
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        var fileData = new FormData(form[0]);
        var card_attachment = new App.CardAttachment();
        card_attachment.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/attachments.json';
        self.closePopup(e);
        card_attachment.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            success: function(model, response) {
                if (is_offline_data) {
                    self.flash('danger', i18next.t('Sorry, attachment not added. Internet connection not available.'));
                } else {
                    $('#js-card-modal-' + self.model.id).parent('.dockmodal-body').prev('.dockmodal-header').find('.cssloader').remove();
                    $('.js-attachment-loader', $('#js-card-modal-' + self.model.id)).html('');
                    var card_attachments = new App.CardAttachmentCollection();
                    var i = 1;
                    card_attachments.add(response.card_attachments);
                    card_attachments.each(function(attachment) {
                        var options = {
                            silent: true
                        };
                        if (i === card_attachments.models.length) {
                            options.silent = false;
                        }
                        attachment.set('id', parseInt(attachment.attributes.id));
                        attachment.set('board_id', parseInt(attachment.attributes.board_id));
                        attachment.set('list_id', parseInt(attachment.attributes.list_id));
                        attachment.set('card_id', parseInt(attachment.attributes.card_id));
                        self.model.attachments.unshift(attachment, options);
                        self.model.list.collection.board.attachments.unshift(attachment, {
                            silent: true
                        });
                        i++;
                    });
                    var view_attachment = this.$('#js-card-attachments-list');
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view_act = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board,
                        flag: '1'
                    });
                    self.model.activities.unshift(activity);
                    if ($.cookie('filter') !== 'comment') {
                        var view_activity = $('#js-card-activities-' + self.model.id);
                        view_activity.prepend(view_act.render().el);
                    }
                    emojify.run();
                }
            }
        });
    },
    /**
     * renderAttachmentsCollection()
     * display attachments in card
     */
    renderAttachmentsCollection: function() {
        var self = this;
        var view_attachment = this.$('#js-card-attachments-list');
        view_attachment.html('');
        this.model.attachments.each(function(attachment) {
            attachment.card_attachments = self.model.attachments;
            var view = new App.CardAttachmentView({
                card_id: self.model.attributes.id,
                model: attachment,
                board: self.model.list.collection.board
            });
            view_attachment.append(view.render().el);
            emojify.run();
        });
        _(function() {
            $(".js-card-attachment-" + self.model.attributes.id).fancybox({
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 600,
                'speedOut': 200,
                'overlayShow': false
            });
        }).defer();
    },
    /**
     * renderLabelsCollection()
     * display labels in card
     */
    renderLabelsCollection: function() {
        var is_edit_labels;
        if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.list.collection.board.acl_links.where({
                slug: "delete_labels",
                board_user_role_id: parseInt(this.model.list.board_user_role_id)
            })))) {
            is_edit_labels = true;
        } else {
            is_edit_labels = false;
        }
        var view_label = this.$el.find('.js-card-labels-list');
        // view_label.html('');
        var self = this;
        this.model.labels.each(function(label) {
            var slabel = self.model.labels.findWhere({
                label_id: label.attributes.label_id
            });
            if (!_.isUndefined(slabel)) {
                var view = new App.CardLabelView({
                    model: slabel,
                    background: self.getLabelcolor('' + slabel.attributes.name).substring(0, 6)
                });
                view_label.prepend(view.render().el);
            }
        });
        _(function() {
            if (!is_edit_labels) {
                if ($('.js-card-dock-modal-' + self.model.id).find('.js-card-labels-list').find('.js-show-card-label-form-response').length > 0) {
                    $('.js-card-dock-modal-' + self.model.id).find('.js-card-labels-list').find('.js-show-card-label-form-response').removeClass('js-show-card-label-form-response');
                }
                if ($('.js-card-dock-modal-' + self.model.id).find('.js-card-labels-list').find('.js-label-dropdown').length > 0) {
                    $('.js-card-dock-modal-' + self.model.id).find('.js-card-labels-list').find('.js-label-dropdown').removeClass(' dropdown');
                }
            }
        }).defer();
    },
    /**
     * renderActivitiesCollection()
     * display card activities
     */
    renderActivitiesCollection: function() {
        var self = this;
        if ((!_.isUndefined(self.model.list) && self.model.list.collection.board.attributes.board_visibility === 2) || (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(self.model.list.collection.board.acl_links.where({
                slug: "view_card_activities",
                board_user_role_id: parseInt(this.model.board_user_role_id)
            }))))) {
            var filter = $.cookie('filter');
            if (!_.isUndefined(filter) && filter === 'activity' && !self.$el.find('#modal-activities').hasClass('active')) {
                self.$el.find('#modal-activities').addClass('active');
            } else if (!_.isUndefined(filter) && filter === 'comment' && !self.$el.find('#modal-comments').hasClass('active')) {
                self.$el.find('#modal-comments').addClass('active');
            } else if (!self.$el.find('#modal-activities').hasClass('active') && !self.$el.find('#modal-comments').hasClass('active')) {
                self.$el.find('#modal-activities').addClass('active');
                self.$el.find('#modal-comments').addClass('active');
            }
            var view_activity = this.$('#js-card-activities-' + self.model.id);
            //view_activity.html('');
            if (!_.isEmpty(this.model.activities)) {
                var i = 1;
                this.model.activities.each(function(activity) {
                    $('#js-loader-img').removeClass('hide');
                    if (!_.isEmpty(self.model.collection)) {
                        activity.cards.add(self.model.collection.models);
                    }
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board,
                        flag: '1'
                    });
                    view_activity.append(view.render().el);
                    $('#js-loader-img').addClass('hide');
                    i++;
                });
                var page_count = $('.js-load-more-block').length + 1;
                if (this.model.attributes.activity_count != PAGING_COUNT && this.model.activities.length >= PAGING_COUNT) {
                    $('#js-card-activities-' + self.model.id).after('<div class="text-center js-load-more-block"><div class="btn btn-primary js-card-activites-load-more js-remove-card-activity" title="' + i18next.t('Load More') + '" data-attr="' + page_count + '" >' + i18next.t('Load next %s of %s', {
                        postProcess: 'sprintf',
                        sprintf: [PAGING_COUNT, this.model.attributes.activity_count]
                    }) + '</div></div>');
                }
            }
            emojify.run();
        }
    },
    /**
     * renderChecklistsCollection()
     * display card checklists
     */
    renderChecklistsCollection: function() {
        if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.list.collection.board.acl_links.where({
                slug: "view_checklist_listing",
                board_user_role_id: parseInt(this.model.board_user_role_id)
            })))) {
            var self = this;
            var view_checklist = this.$('#js-card-checklists');
            view_checklist.html('');
            var checklists = this.model.list.collection.board.checklists.where({
                card_id: parseInt(this.model.attributes.id)
            });
            this.model.checklists.reset(checklists);
            this.model.checklists.sortByColumn('position');
            this.model.checklists.each(function(checklist) {
                var checklist_items = self.model.list.collection.board.checklist_items.where({
                    card_id: parseInt(self.model.attributes.id),
                    checklist_id: parseInt(checklist.attributes.id)
                });
                checklist.checklist_items.reset(checklist_items);
                checklist.card = self.model;
                checklist.board_users = self.model.board_users;
                var view = new App.CardCheckListView({
                    model: checklist,
                    attributes: {
                        'data-checklist_id': checklist.attributes.id
                    }
                });
                view_checklist.append(view.render().el);
            });
        }
    },
    /**
     * renderUsersCollection()
     * display card users
     */
    renderUsersCollection: function() {
        var view_user = this.$('#js-card-user-add-container');
        this.$el.find('.js-organization-member-search-response').html('');
        view_user.prevAll().remove();
        var content = '';
        var self = this;
        this.model.users.each(function(user) {
            var content_img = '<i class="avatar avatar-color-194 img-rounded" title="' + user.get('full_name') + ' (' + user.get('username') + ')" data-container="body" data-toggle="tooltip">' + user.get('initials') + '</i>';
            var profile_picture_path = user.get('profile_picture_path');
            if (!_.isEmpty(profile_picture_path)) {
                var hash = calcMD5(SecuritySalt + 'User' + user.attributes.user_id + 'png' + 'small_thumb');
                profile_picture_path = window.location.pathname + 'img/small_thumb/User/' + user.attributes.user_id + '.' + hash + '.png';
                content_img = '<img src="' + profile_picture_path + '" alt="' + user.get('username') + '" title="' + user.get('full_name') + ' (' + user.get('username') + ')" class="img-rounded img-responsive avatar" data-container="body" data-toggle="tooltip">';
            }
            if (!isNaN(user.attributes.user_id)) {
                content += '<li class="js-added-card-user-' + user.attributes.user_id + '"><div class="dropdown js-member-dropdown"> <a class="dropdown-toggle js-show-add-member-form" role="button" data-toggle="dropdown" title="' + user.attributes.username + '" href="#"> ' + content_img + '</a><ul class="dropdown-menu dropdown-menu-left arrow col-xs-12"><li> <div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>Members</strong></span><i class="icon-remove cur no-print"></i></div></li><li class="col-xs-12 divider"></li><li class="col-xs-12"><form method="post" class="text-center" name="addMember"><div class="form-group"><label class="sr-only">Search Member</label><input type="text" autocomplete="off" id="inputOrganizationUserSearch" placeholder="Search Members" name="email" required class="js-search-users form-control input-sm" title="Search Members"></div></form></li><li class="js-organization-member-search-response col-xs-12 small">Search for a person by name or email address.</li></ul></div></li>';
            }
        });
        if (view_user.length > 0) {
            view_user.before(content);
        } else {
            self.$('#js-card-users-list-' + self.model.id).append(content);
        }
    },
    /**
     * showChecklistAddForm()
     * display checklist add form users
     * @param e
     * @type Object(DOM event)
     */
    showChecklistAddForm: function(e) {
        $('.js-checklist-add-form-response').html(new App.ChecklistAddFormView({
            model: this.model
        }).el);
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        return false;
    },
    /**
     * addChecklist()
     * add checklist in card
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    addChecklist: function(e) {
        e.preventDefault();
        var self = this;
        var target = $(e.target);
        var data = target.serializeObject();
        data.uuid = new Date().getTime();
        target.parents('li.dropdown').removeClass('open');
        var postion = self.model.checklists.max(function(checklist) {
            return (!_.isUndefined(checklist)) ? checklist.attributes.position : 1;
        });
        data.position = (!_.isUndefined(postion) && !_.isEmpty(postion)) ? postion.get('position') + 1 : 1;
        var card_checklist = new App.CheckList();
        card_checklist.set('is_offline', true);
        card_checklist.url = api_url + 'checklists.json';
        card_checklist.set('card_id', self.model.id);
        card_checklist.set('list_id', self.model.attributes.list_id);
        card_checklist.set('board_id', self.model.attributes.board_id);
        card_checklist.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/checklists.json';
        card_checklist.save(data, {
            success: function(model, response, options) {
                if (_.isUndefined(options.temp_id)) {
                    card_checklist.set('is_offline', false);
                }
                if (!_.isUndefined(response.checklist) && _.isUndefined(options.temp_id)) {
                    card_checklist.set({
                        id: parseInt(response.checklist.id)
                    });
                } else {
                    global_uuid[data.uuid] = options.temp_id;
                    card_checklist.set('id', data.uuid);
                }
                card_checklist.set('checklist_item_completed_count', 0);
                card_checklist.set('name', _.escape(data.name));
                card_checklist.set('card_id', self.model.id);
                card_checklist.set('list_id', self.model.attributes.list_id);
                card_checklist.set('board_id', self.model.attributes.board_id);
                card_checklist.card = self.model;
                if (!_.isUndefined(response.checklist)) {
                    var checklist_items = response.checklist.checklists_items;
                    card_checklist.set('checklist_items', checklist_items);
                    _.each(response.checklist.checklists_items, function(item) {
                        checklist_item = new App.CheckListItem();
                        checklist_item.set('id', parseInt(item.id));
                        checklist_item.set('card_id', self.model.id);
                        checklist_item.set('user_id', parseInt(item.user_id));
                        checklist_item.set('checklist_id', card_checklist.id);
                        checklist_item.set('name', item.name);
                        checklist_item.set('is_completed', 0);
                        checklist_item.card = self.model.card;
                        checklist_item.checklist = new App.CheckList();
                        checklist_item.checklist = self.model;
                        self.model.list.collection.board.checklist_items.add(checklist_item);
                    });

                } else {
                    if (data.checklist_id !== '0') {
                        var _checklist_items = self.model.list.collection.board.checklist_items.where({
                            checklist_id: parseInt(data.checklist_id)
                        });
                        _.each(_checklist_items, function(item) {
                            checklist_item = new App.CheckListItem();
                            checklist_item.set('id', new Date().getTime());
                            checklist_item.set('card_id', self.model.id);
                            checklist_item.set('user_id', parseInt(item.attributes.user_id));
                            checklist_item.set('checklist_id', card_checklist.id);
                            checklist_item.set('name', item.attributes.name);
                            checklist_item.set('is_completed', 0);
                            checklist_item.card = self.model.card;
                            checklist_item.checklist = new App.CheckList();
                            checklist_item.checklist = self.model;
                            self.model.list.collection.board.checklist_items.add(checklist_item);
                        });
                    }
                }
                self.model.list.collection.board.checklists.add(card_checklist);
                self.model.checklists.add(card_checklist);

                $('.js-card-checklist').each(function() {
                    var id = $(this).attr("data-checklist_id");
                    if (card_checklist.id == $(this).attr("data-checklist_id")) {
                        $(this).find('.js-add-item-view').trigger('click');
                    }
                });

                var __checklist_items = self.model.list.collection.board.checklist_items.where({
                    card_id: parseInt(self.model.attributes.id)
                });
                items = new App.CheckListItemCollection();
                items.add(__checklist_items);
                var completed_count = items.filter(function(checklist_item) {
                    return parseInt(checklist_item.get('is_completed')) === 1;
                }).length;
                var total_count = items.models.length;
                self.model.set('checklist_item_completed_count', completed_count);
                self.model.set('checklist_item_count', total_count);

                if (!_.isUndefined(response.activity)) {
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view_act = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board,
                        flag: '1'
                    });
                    self.model.activities.unshift(activity);
                    if ($.cookie('filter') !== 'comment') {
                        var view_activity = $('#js-card-activities-' + self.model.id);
                        view_activity.prepend(view_act.render().el);
                    }
                }
            }
        });
        return false;
    },
    /**
     * showAddMemberForm()
     * display card member add form
     * @param e
     * @type Object(DOM event)
     */
    showAddMemberForm: function(e) {
        e.preventDefault();
        $('.js-add-member-response').html(new App.ModalCardMemberFormView({
            model: this.model.board_users,
            users: this.model.users,
            card: this.model
        }).el);
        this.renderBoardUsers();
        this.showTooltip();
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        if (target.hasClass('js-card-header-action')) {
            return false;
        }
    },
    /**
     * addCardMember()
     * add card member
     * @param e
     * @type Object(DOM event)
     */
    addCardMember: function(e) {
        e.preventDefault();
        var self = this;
        var target = $(e.currentTarget);
        var uuid = new Date().getTime();
        target.removeClass('js-add-card-member').addClass('js-remove-card-member').append('<i class="icon-ok"></i>');
        var user_id = target.data('user-id');
        var user_name = target.data('user-name');
        var user_initial = target.data('user-initial');
        var user_profile_picture_path = target.data('user-profile-picture-path');
        var full_name = target.data('user-fullname');
        var content_img = '<i class="avatar avatar-color-194 img-rounded" title="' + full_name + ' (' + user_name + ')">' + user_initial + '</i>';
        if (!_.isEmpty(user_profile_picture_path)) {
            var hash = calcMD5(SecuritySalt + 'User' + user_id + 'png' + 'small_thumb');
            var profile_picture_path = window.location.pathname + 'img/small_thumb/User/' + user_id + '.' + hash + '.png';
            content_img = '<img src="' + profile_picture_path + '" alt="' + user_name + '" title="' + full_name + ' (' + user_name + ')" class="img-rounded img-responsive avatar">';
        }
        var view_user = $('#js-card-users-list-' + self.model.id).prepend('<li class="js-added-card-user-' + user_id + '">' + content_img + '</li>');
        $('#js-card-user-add-container .js-member-dropdown').removeClass('open');
        var card_user = new App.CardUser();
        card_user.set('uuid', uuid);
        card_user.set('is_offline', true);
        card_user.set('user_id', user_id);
        card_user.set('card_id', self.model.id);
        card_user.set('board_id', self.model.attributes.board_id);
        card_user.set('list_id', self.model.attributes.list_id);
        card_user.set('profile_picture_path', user_profile_picture_path);
        card_user.set('username', user_name);
        card_user.set('initials', user_initial);
        card_user.set('full_name', full_name);
        self.model.users.add(card_user, {
            silent: true
        });
        self.renderUsersCollection();
        card_user.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/users/' + user_id + '.json';
        card_user.save({
            user_id: user_id,
            card_id: self.model.id
        }, {
            success: function(model, response, options) {
                if (_.isUndefined(options.temp_id)) {
                    card_user.set('is_offline', false);
                }
                target.attr('data-card-user-id', response.id);
                if (self.model.users.models.length > 0) {
                    self.model.users.findWhere({
                        'user_id': user_id,
                        'card_id': self.model.id
                    }).set('id', parseInt(response.id));
                }
                if (!_.isUndefined(response.id) && _.isUndefined(options.temp_id)) {
                    card_user.set({
                        id: parseInt(response.id)
                    });
                } else {
                    global_uuid[uuid] = options.temp_id;
                    card_user.set('id', uuid);
                }
                if (!_.isUndefined(response.activity)) {
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board,
                        flag: '1'
                    });
                    self.model.activities.unshift(activity);
                    if ($.cookie('filter') !== 'comment') {
                        var view_activity = $('#js-card-activities-' + self.model.id);
                        view_activity.prepend(view.render().el);
                    }
                }
            }
        });
        return false;
    },
    /**
     * removeCardMember()
     * remove card member
     * @param e
     * @type Object(DOM event)
     */
    removeCardMember: function(e) {
        e.preventDefault();
        var target = $(e.currentTarget);
        var user_id = target.attr('data-user-id');
        var id = target.attr('data-card-user-id');
        target.removeClass('js-remove-card-member').addClass('js-add-card-member');
        $('i.icon-ok', target).remove();
        var card_user = this.model.users.findWhere({
            'user_id': user_id,
            'card_id': this.model.id
        });
        $('#js-card-users-list-' + id).find('.js-added-card-user-' + user_id).remove();
        if (!_.isUndefined(card_user) || (!_.isUndefined(id) && id !== '')) {
            card_user = new App.CardUser();
            card_user.set('id', id);
            card_user.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '/cards_users/' + id + '.json';

        } else {
            card_user = new App.CardUser();
            card_user.set('id', user_id);
            card_user.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '/users/' + user_id + '.json';
        }
        card_user.destroy();
        this.model.users.remove(card_user);
        this.renderUsersCollection();
        return false;
    },
    /**
     * showAddCommentForm()
     * display card comment form
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    showAddCommentForm: function(e) {
        $('.js-add-comment-response').html(new App.ActivityAddFormView({
            model: this.model
        }).el);
        return false;
    },
    /**
     * showReplyCommentForm()
     * display reply comment form
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    showReplyCommentForm: function(e) {
        var activity_id = $(e.currentTarget).data('activity-id');
        var activitiy = this.model.activities.get({
            id: activity_id
        });
        $('.js-acticity-action-' + activity_id).addClass('hide');
        $('.js-activity-reply-form-response-' + activity_id).html(new App.ActivityReplyFormView({
            model: activitiy
        }).el);
        return false;
    },
    /**
     * addComment()
     * save comment
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    addComment: function(e) {
        $('#submitCommentAdd').addClass('disabled');
        $('#js-add-organization').addClass('disabled');
        e.preventDefault();
        if (!$.trim($(e.target).find('#inputAddComment').val()).length) {
            $(e.target).find('.error-msg').remove();
            $('<div class="error-msg text-primary h6">Whitespace is not allowed</div>').insertAfter($(e.target).find('#inputAddComment'));
        } else {
            $(e.target).find('.error-msg').remove();
            var self = this;
            $('.js-add-comment-response').html('<span class="js-show-add-comment-form cur">' + i18next.t('Add Comment') + '</span>');
            var board_id = this.model.attributes.board_id;
            var data = $(e.target).serializeObject();
            var is_reply = $(e.target).hasClass('js-reply-form');
            if (!is_reply) {
                $(e.target)[0].reset();
                var doc = $('#js-card-modal-' + this.model.id);
                $(doc).find('.js-show-comment').trigger('click');
            }
            // Create UUID and push into list and render immediately
            data.uuid = new Date().getTime();
            data.board_id = board_id;
            data.list_id = this.model.attributes.list_id;
            data.card_id = this.model.id;
            data.user_id = authuser.user.id;
            var push_data = data;
            var activity = new App.Activity();
            activity.set('is_offline', true);
            activity.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '/comments.json';
            activity.save(data, {
                success: function(model, response, options) {
                    $('#submitCommentAdd').removeClass('disabled');
                    if (_.isUndefined(options.temp_id)) {
                        activity.set('is_offline', false);
                    }
                    if (!_.isUndefined(response.id) && _.isUndefined(options.temp_id)) {
                        activity.set({
                            id: parseInt(response.id)
                        });
                    } else {
                        global_uuid[data.uuid] = options.temp_id;
                        activity.set('id', data.uuid);
                    }
                    if (!_.isUndefined(response.activities)) {
                        model.set('created', response.activities.created);
                        activity.set('created', response.activities.created);
                        activity.set('depth', response.activities.depth);
                    }

                    model.set('type', 'add_comment');
                    activity.set('username', authuser.user.username);
                    activity.set('profile_picture_path', authuser.user.profile_picture_path);
                    activity.set('initials', authuser.user.initials);
                    self.model.activities.unshift(activity, {
                        silent: true
                    });
                    self.model.list.collection.board.activities.add(activity, {
                        silent: true
                    });
                    model.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: model,
                        board: self.model.list.collection.board,
                        flag: '1'
                    });
                    var current_card = self.model.list.collection.board.cards.get(self.model.id);
                    var comment_count = (!_.isUndefined(current_card)) ? (parseInt(current_card.attributes.comment_count) + 1) : 0;
                    comment_count = isNaN(comment_count) ? 1 : comment_count;
                    self.model.list.collection.board.cards.get(self.model.id).set('comment_count', comment_count);
                    self.model.set('comment_count', comment_count);
                    self.model.attributes.comment_count = comment_count;
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    if (!_.isEmpty(data.root)) {
                        $(view.render().el).insertAfter($('.js-list-activity-' + data.root));
                    } else {
                        view_activity.prepend(view.render().el);
                    }
                    $("#inputAddComment").html('');
                    emojify.run();
                    self.hideReplyCommentForm();

                }
            });
        }
        return false;
    },
    /**
     * showEditCommentForm()
     * display comment edit form
     * @param e
     * @type Object(DOM event)
     */
    showEditCommentForm: function(e) {
        e.preventDefault();
        var self = this;
        var activity_id = $(e.target).data('activity-id');
        var temp_id = $(e.target).data('activity-temp-id');
        $('.js-acticity-action-' + activity_id).addClass('hide');
        $('.js-timeago-' + activity_id).addClass('hide');
        var activity = self.model.activities.get({
            id: parseInt(activity_id)
        });
        activity.board_user_role_id = self.model.board_user_role_id;
        activity.board = self.model.board;
        $('.js-list-activity-' + activity_id).addClass('edit-comment');
        $('.js-activity-' + activity_id).html(new App.EditActivityFormView({
            model: activity,
            attributes: {
                'data-activity-id': activity_id,
                'data-activity-temp-id': temp_id
            }
        }).el);
        $('.js-inputComment', e.target).focus();
    },
    /**
     * editComment()
     * update comment
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editComment: function(e) {
        e.preventDefault();
        if (!$.trim($('.js-inputComment').val()).length) {
            $('.error-msg').remove();
            $('<div class="error-msg text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('.js-inputComment');
        } else {
            $('.error-msg').remove();
            var self = this;
            var activity_id = $(e.currentTarget).data('activity-id');
            var temp_id = $(e.currentTarget).data('activity-temp-id');
            var current_card = this.model.activities.get({
                id: activity_id
            });
            var board_id = current_card.attributes.board_id;
            var list_id = current_card.attributes.list_id;
            var card_id = current_card.attributes.card_id;
            var data = $(e.target).serializeObject();
            $('.js-activity-' + activity_id).html('<div class="panel no-mar"><div class="panel-body github-markdown">' + this.converter.makeHtml(data.comment) + '</div></div>');
            $('.js-acticity-action-' + activity_id).removeClass('hide');
            $('.js-timeago-' + activity_id).removeClass('hide');
            //Update in list table
            var activity = new App.Activity();
            activity.id = parseInt(activity_id);
            activity.set('is_offline', true);
            activity.set('temp_id', temp_id);
            activity.url = api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards/' + card_id + '/comments/' + activity_id + '.json';
            activity.save(data, {
                success: function(model, response) {
                    var current_comment = self.model.activities.get({
                        id: activity_id
                    });
                    current_comment.set('comment', data.comment);
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board,
                        flag: '1'
                    });
                    self.model.activities.unshift(activity);
                    if ($.cookie('filter') !== 'comment') {
                        var view_activity = $('#js-card-activities-' + self.model.id);
                        view_activity.prepend(view.render().el);
                    }
                    emojify.run();
                    self.hideReplyCommentForm();
                }
            });
        }
        return false;
    },
    /**
     * hideEditCommentForm()
     * hide update comment form
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    hideEditCommentForm: function() {
        var activity_id = this.$el.find('.js-hide-edit-comment-form').data('activity-id');
        var current_card = this.model.activities.get({
            id: activity_id
        });
        parse_date(current_card.attributes.created, authuser, 'js-timeago-' + current_card.attributes.id);
        var html_content = '<div class="panel no-mar"><div class="panel-body github-markdown">' + makeLink(this.converter.makeHtml(current_card.attributes.comment), current_card.attributes.board_id) + '</div></div>';
        this.$el.find('.js-hide-edit-comment-form').parents('div.js-activity-' + activity_id).html(html_content);
        $('.js-acticity-action-' + activity_id).removeClass('hide');
        $('.js-timeago-' + activity_id).removeClass('hide');
    },
    /**
     * hideReplyCommentForm()
     * hide reply comment form
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    hideReplyCommentForm: function() {
        var activity_id = this.$el.find('.js-hide-reply-comment-form').data('activity-id');
        $('.js-activity-reply-form-response-' + activity_id).html('');
        $('.js-acticity-action-' + activity_id).removeClass('hide');
    },
    /**
     * showConfirmCommentDelete()
     * display comment delete confirmation
     * @param e
     * @type Object(DOM event)
     */
    showConfirmCommentDelete: function(e) {
        e.preventDefault();
        var activity_id = $(e.currentTarget).data('activity-id');
        $(e.currentTarget).siblings('ul').find('#js-acticity-actions-response-' + activity_id).html(new App.ActivityDeleteConfirmView({
            model: activity_id
        }).el);
    },
    /**
     * deleteComment()
     * delete comment
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    deleteComment: function(e) {
        var self = this;
        var activity_id = $(e.currentTarget).data('activity-id');
        var current_card = this.model.activities.get({
            id: activity_id
        });
        var list_id = this.model.attributes.list_id;
        var card_id = this.model.id;
        var board_id = this.model.attributes.board_id;
        this.model.activities.remove({
            id: activity_id
        });
        this.model.list.collection.board.activities.remove({
            id: parseInt(activity_id)
        });
        var activity = new App.Activity();
        activity.set('id', activity_id);
        activity.url = api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards/' + card_id + '/comments/' + activity_id + '.json';
        $(e.currentTarget).parents('li.js-activity').remove();
        activity.destroy({
            success: function(model, response) {
                var activity = new App.Activity();
                activity.set(response.activity);
                activity.board_users = self.model.board_users;
                var view = new App.ActivityView({
                    model: activity,
                    board: self.model.list.collection.board,
                    flag: '1'
                });
                self.model.activities.unshift(activity);
                var current_card = self.model.list.collection.board.cards.get(card_id);
                self.model.list.collection.board.cards.get(card_id).set('comment_count', parseInt(response.activity.comment_count));
                self.model.set('comment_count', parseInt(response.activity.comment_count));
                if ($.cookie('filter') !== 'comment') {
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view.render().el);
                }
                return false;
            }
        });
    },
    /**
     * addCardAttachmentLink()
     * add  attachment link in card
     * @param e
     * @type Object(DOM event)
     */
    addCardAttachmentLink: function(e) {
        e.preventDefault();
        var self = this;
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        var data = target.serializeObject();
        target[0].reset();
        var card_attachment = new App.CardAttachment();
        card_attachment.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/attachments.json';
        card_attachment.save(data, {
            success: function(model, response) {
                if (is_offline_data) {
                    self.flash('danger', i18next.t('Sorry, attachment not added. Internet connection not available.'));
                } else {
                    self.closePopup(e);
                    card_attachment.set(response.card_attachments);
                    card_attachment.set('id', parseInt(response.card_attachments.id));
                    card_attachment.set('board_id', parseInt(response.card_attachments.board_id));
                    card_attachment.set('list_id', parseInt(response.card_attachments.list_id));
                    card_attachment.set('card_id', parseInt(response.card_attachments.card_id));
                    self.model.list.collection.board.attachments.unshift(card_attachment, {
                        silent: true
                    });
                    self.model.attachments.unshift(card_attachment, {
                        silent: true
                    });
                    var view = new App.CardAttachmentView({
                        model: card_attachment,
                        board: self.model.list.collection.board
                    });
                    var view_attachment = self.$('#js-card-attachments-list');
                    view_attachment.append(view.render().el);
                }
            }
        });
    },
    /**
     * showCardVotersList()
     * display card voters list
     * @param e
     * @type Object(DOM event)
     */
    showCardVotersList: function(e) {
        e.preventDefault();
        $('.js-show-card-voters-list-response').html(new App.CardVotersListView({
            model: this.model
        }).el);
        this.showTooltip();
    },
    /**
     * removeDueDate()
     * delete card due date
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    removeDueDate: function(e) {
        e.preventDefault();
        var self = this;
        if (!_.isEmpty(this.model.attributes.due_date) && this.model.attributes.due_date !== '') {
            this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '.json';
            this.model.set('due_date', null);
            this.model.save({
                due_date: 'NULL'
            }, {
                patch: true,
                success: function(model, response) {
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board,
                        flag: '1'
                    });
                    self.model.activities.unshift(activity);
                    if ($.cookie('filter') !== 'comment') {
                        var view_activity = $('#js-card-activities-' + self.model.id);
                        view_activity.prepend(view.render().el);
                    }
                }
            });
        }
    },
    /**
     * showSearchUsers()
     * display searched board user list
     */
    showSearchUsers: function(e) {
        var self = this;
        var q = $(e.target).val();
        if (q !== '') {
            var filtered_users = this.model.list.collection.board.board_users.search(q);
            var users = new App.UserCollection();
            users.setSortField('username', 'asc');
            users.sort();
            if (!_.isEmpty(filtered_users._wrapped)) {
                $.unique(filtered_users._wrapped);
            }
            users.add(filtered_users._wrapped);
            $('.js-organization-member-search-response').html('');
            if (!_.isEmpty(users.models)) {
                _.each(users.models, function(user) {
                    var added_user = self.model.users.findWhere({
                        card_id: self.model.id,
                        user_id: user.attributes.user_id
                    });
                    var is_added_user = (!_.isUndefined(added_user)) ? true : false;
                    $('.js-organization-member-search-response').append(new App.CardSearchUsersResultView({
                        model: user,
                        is_added_user: is_added_user,
                        added_user: added_user,
                        board: self.model.list.collection.board
                    }).el);
                });
            } else {
                $('.js-organization-member-search-response').html(new App.CardSearchUsersResultView({
                    model: null
                }).el);
            }
        } else {
            this.$el.find('.js-organization-member-search-response').html('');
            this.renderBoardUsers();
        }

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
     * showSearchCards()
     * display searched card result
     * @param string
     * @type string
     */
    showSearchCards: function(e) {
        var target = $(e.target);
        var self = this;
        var q = $(target).val();
        var cards = new App.CardCollection();
        cards.url = api_url + 'boards/' + this.model.attributes.board_id + '/cards/search.json';
        cards.fetch({
            data: {
                q: q
            },
            success: function() {
                self.$el.find('.js_activity_card_search_response').nextAll().remove();
                if (!_.isEmpty(cards.models)) {
                    _.each(cards.models, function(card) {
                        $(new App.ActivityCardSearchView({
                            model: card
                        }).el).insertAfter(self.$el.find('.js_activity_card_search_response'));
                    });
                } else {
                    $(new App.ActivityCardSearchView({
                        model: null
                    }).el).insertAfter(self.$el.find('.js_activity_card_search_response'));
                }
            }
        });
    },
    /**
     * AddCommentCard()
     * add card comment
     * @param string
     * @type string
     */
    AddCommentCard: function(e) {
        e.preventDefault();
        var target = $(e.currentTarget);
        var card_id = target.data('card-id');
        var card_name = target.data('card-name');
        var board_id = target.data('board-id');
        if ($(target).parents('.comment-block').length > 0) {
            $(target).parents('.comment-block').find('.js-comment').val($(target).parents('.comment-block').find('.js-comment').val() + '#' + card_id + ' ');
        } else {
            $(target).parents('#AddActivityForm').find('.js-comment').val($(target).parents('#AddActivityForm').find('.js-comment').val() + '#' + card_id + ' ');
        }
    },
    /**
     * changeList()
     * change list based on selected board
     * @param string
     * @type string
     */
    changeList: function(e) {
        e.preventDefault();
        e.stopPropagation();
        var target = $(e.currentTarget);
        target.blur();
        var self = this;
        var board_id = parseInt(target.val());
        var content_list = '';
        var content_position = '';
        if (board_id == this.model.attributes.board_id) {
            this.showMoveCardForm(e);
        } else {
            var board = self.boards.findWhere({
                id: parseInt(board_id),
                is_closed: 0
            });
            board.lists.add(board.attributes.lists);
            var board_lists = board.lists.where({
                is_archived: 0
            });
            var current_position = this.model.collection.indexOf(this.model) + 1;
            var is_first_list = true;
            var wip_enabled = false;
            if (!_.isUndefined(APPS) && APPS !== null) {
                if (!_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
                    if ($.inArray('r_wip_limit', APPS.enabled_apps) !== -1) {
                        wip_enabled = true;
                    }
                }
            }
            _.each(board_lists, function(list) {
                if (self.model.attributes.list_id == list.attributes.id) {
                    content_list += '<option value="' + list.id + '" selected="selected">' + _.escape(list.attributes.name) + ' ' + i18next.t('(current)') + '</option>';
                    is_first_list = true;
                } else {
                    if (wip_enabled && !_.isUndefined(list.attributes.custom_fields) && list.attributes.custom_fields) {
                        var wip_limit_count = JSON.parse(list.attributes.custom_fields);
                        if (parseInt(wip_limit_count.wip_limit) !== parseInt(list.attributes.card_count)) {
                            content_list += '<option value="' + list.id + '">' + _.escape(list.attributes.name) + '</option>';
                        }
                    } else {
                        content_list += '<option value="' + list.id + '">' + _.escape(list.attributes.name) + '</option>';
                    }
                }
                if (is_first_list) {
                    is_first_list = false;
                    for (var i = 1; i <= list.attributes.card_count; i++) {
                        if (self.model.attributes.list_id == list.attributes.id && i == current_position) {
                            content_position += '<option value="' + i + '" selected="selected">' + i + ' ' + i18next.t('(current)') + '</option>';
                        } else {
                            content_position += '<option value="' + i + '">' + i + '</option>';
                        }
                    }
                    if (self.model.attributes.list_id != list.attributes.id) {
                        var next_position = parseInt(list.attributes.card_count) + 1;
                        content_position += '<option value="' + next_position + '">' + next_position + '</option>';
                    }
                }
            });
            self.$el.find('.js-change-position').html(content_list);
            self.$el.find('.js-position').html(content_position);
        }
    },
    /**
     * changePosition()
     * change position based on selected list
     * @param string
     * @type string
     */
    changePosition: function(e) {
        var target = $(e.currentTarget);
        var self = this;
        var list_id = target.val();
        var board_id = target.parent().prev().find('.js-change-list').val();
        var content_position = '';
        var board = self.boards.findWhere({
            id: parseInt(board_id)
        });
        var list = board.lists.findWhere({
            id: parseInt(list_id)
        });
        var current_position = this.model.collection.indexOf(this.model) + 1;
        for (var i = 1; i <= list.attributes.card_count; i++) {
            if (self.model.attributes.list_id == list.attributes.id && i == current_position) {
                content_position += '<option value="' + self.model.attributes.position + '" selected="selected">' + self.model.attributes.position + ' ' + i18next.t('(current)') + '</option>';
            } else {
                content_position += '<option value="' + i + '">' + i + '</option>';
            }
        }
        if (this.model.attributes.list_id != list.attributes.id) {
            var next_position = parseInt(list.attributes.card_count) + 1;
            if (isNaN(list.attributes.card_count))
                next_position = 1;
            content_position += '<option value="' + next_position + '">' + next_position + '</option>';
        }
        self.$el.find('.js-position').html(content_position);
    },
    /**
     * showCopyCardForm()
     * display copy card form
     * @param string
     * @type string
     */
    showCopyCardForm: function(e) {
        e.preventDefault();
        $('.js-show-copy-card-form-response').html(new App.CopyCardView({
            model: this.model,
            boards: this.boards
        }).el);
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        return false;
    },
    /**
     * showMoreForm()
     * display More
     * @param string
     * @type string
     */
    showMoreForm: function(e) {
        e.preventDefault();
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        return false;
    },
    /**
     * copyCard()
     * save copied card
     * @param string
     * @type string
     */
    copyCard: function(e) {
        e.preventDefault();
        var self = this;
        var data = $(e.currentTarget).serializeObject();
        data.uuid = new Date().getTime();
        var card = new App.Card();
        card.set('is_offline', true);
        this.closePopup(e);
        var current_card = this.model.attributes;
        data.board_id = parseInt(data.board_id);
        card.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '/copy.json';
        card.save(data, {
            patch: true,
            success: function(model, response, options) {
                if (_.isUndefined(options.temp_id)) {
                    card.set('is_offline', false);
                }
                if (data.board_id === current_card.board_id) {
                    card.set(response.cards);
                    if (parseInt(response.cards.is_archived) === 0) {
                        card.set('is_archived', 0);
                    } else {
                        card.set('is_archived', 1);
                    }
                    card.set('list_id', parseInt(response.cards.list_id));
                    card.set('board_id', parseInt(response.cards.board_id));
                    card.set('id', parseInt(response.id));
                    card.board_users = self.model.list.board_users;
                    card.list = self.model.list;
                    if (!_.isUndefined(response.id) && _.isUndefined(options.temp_id)) {
                        card.set({
                            id: parseInt(response.id)
                        });
                    } else {
                        global_uuid[data.uuid] = options.temp_id;
                        card.set('id', data.uuid);
                    }
                    self.model.list.collection.get(data.list_id).cards.add(card);
                    var list = App.boards.get(response.cards.board_id).lists.get(response.cards.list_id);
                    if (!_.isUndefined(list)) {
                        list.set('card_count', list.attributes.card_count + 1);
                    }
                    var i = 1;
                    _.each(response.cards.attachments, function(attachment) {
                        var options = {
                            silent: true
                        };
                        if (i === response.cards.attachments.length) {
                            options.silent = false;
                        }
                        var new_attachment = new App.CardAttachment();
                        new_attachment.set(attachment);
                        new_attachment.set('id', parseInt(attachment.id));
                        new_attachment.set('board_id', parseInt(attachment.board_id));
                        new_attachment.set('list_id', parseInt(attachment.list_id));
                        new_attachment.set('card_id', parseInt(attachment.card_id));
                        self.model.list.collection.get(data.list_id).cards.get(parseInt(attachment.card_id)).attachments.unshift(new_attachment, options);
                        self.model.list.collection.board.attachments.unshift(new_attachment, options);
                        i++;
                    });
                    i = 0;
                    _.each(response.cards.activities, function(activity) {
                        var options = {
                            silent: true
                        };
                        if (i === response.cards.activities.length) {
                            options.silent = false;
                        }
                        var new_activity = new App.Activity();
                        new_activity.set(activity);
                        new_activity.set('id', parseInt(activity.id));
                        new_activity.set('board_id', parseInt(activity.board_id));
                        new_activity.set('list_id', parseInt(activity.list_id));
                        new_activity.set('card_id', parseInt(activity.card_id));
                        self.model.list.collection.board.activities.add(new_activity, options);
                        self.model.activities.unshift(new_activity, options);
                        i++;
                    });
                    self.model.list.collection.board.cards.add(card);
                    var change_list_card_count = parseInt(self.boards.get(data.board_id).lists.get(data.list_id).get('card_count'));
                    if (parseInt(change_list_card_count) === 1) {
                        // Removing the &nbsp; from the new list
                        $('#js-card-listing-' + data.list_id).html(function(i, h) {
                            return h.replace(/&nbsp;/g, '');
                        });
                    }
                    if (!_.isUndefined(response.cards.cards_checklists) && !_.isEmpty(response.cards.cards_checklists)) {
                        if (response.cards.cards_checklists.length > 0) {
                            _.each(response.cards.cards_checklists, function(card_checklist) {
                                self.model.list.collection.board.checklists.add(card_checklist);
                                var checklist = self.model.list.collection.board.checklists.get(parseInt(card_checklist.id));
                                var checklist_items = card_checklist.checklists_items;
                                _.each(checklist_items, function(item) {
                                    checklist_item = new App.CheckListItem();
                                    checklist_item.set('id', parseInt(item.id));
                                    checklist_item.set('card_id', parseInt(response.cards.id));
                                    checklist_item.set('list_id', parseInt(response.cards.list_id));
                                    checklist_item.set('board_id', parseInt(response.cards.board_id));
                                    checklist_item.set('user_id', parseInt(item.user_id));
                                    checklist_item.set('checklist_id', parseInt(checklist.attributes.id));
                                    checklist_item.set('name', item.name);
                                    checklist_item.set('is_completed', item.is_completed);
                                    checklist_item.card = card;
                                    checklist_item.checklist = new App.CheckList();
                                    checklist_item.checklist = checklist;
                                    self.model.list.collection.board.checklist_items.add(checklist_item);
                                });
                            });
                        }
                    }
                    self.model.list.collection.board.labels.add(response.cards.cards_labels);
                }
                var activity = new App.Activity();
                activity.set(response.activity);
                activity.board_users = self.model.board_users;
                var view = new App.ActivityView({
                    model: activity,
                    board: self.model.list.collection.board,
                    flag: '1'
                });
                self.model.activities.unshift(activity);
                if ($.cookie('filter') !== 'comment') {
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view.render().el);
                }
            }
        });

    },
    /**
     * showSearchMembers()
     * display searched member list
     */
    showSearchMembers: function(e) {
        var self = this;
        var target = $(e.target);
        var q = $(target).val();
        if (q !== '') {
            var filtered_users = this.model.list.collection.board.board_users.search(q);
            var users = new App.UserCollection();
            if (!_.isEmpty(filtered_users._wrapped)) {
                $.unique(filtered_users._wrapped);
            }
            users.add(filtered_users._wrapped);
            $(target).parents('.js-comment-member-search-response').nextAll().remove();
            if (!_.isEmpty(users.models)) {
                _.each(users.models, function(user) {
                    $(new App.ActivityUserAddSearchResultView({
                        model: user
                    }).el).insertAfter($(target).parents('.js-comment-member-search-response'));
                });
                if (users.models.length === 0) {
                    $(new App.ActivityUserAddSearchResultView({
                        model: null
                    }).el).insertAfter($(target).parents('.js-comment-member-search-response'));
                }
            } else {
                $(new App.ActivityUserAddSearchResultView({
                    model: null
                }).el).insertAfter($(target).parents('.js-comment-member-search-response'));
            }
        } else {
            $(target).parents('.js-comment-member-search-response').nextAll().remove();
            this.renderActivityBoardUsers();
        }
    },
    /**
     * AddCommentMember()
     * mention member in comment
     * @param string
     * @type string
     */
    AddCommentMember: function(e) {
        e.preventDefault();
        var str = this.$el.find('.current-comment-box').val();
        var autoMentionSelectionStart = this.autoMentionSelectionStart;
        var member = '';
        if (_.isEmpty(this.$el.find('.js-search-member').val())) {
            this.$el.find(".current-comment-box").each(function(i) {
                member = '@' + $(e.currentTarget).data('user-name');
                if (_.isUndefined(autoMentionSelectionStart) || parseInt(autoMentionSelectionStart) === 0) {
                    this.value = this.value + ' ' + member;
                    this.focus();
                } else {
                    if (document.selection) {
                        //For browsers like Internet Explorer
                        sel = document.selection.createRange();
                        sel.text = member;
                        this.focus();
                    } else if (this.selectionStart || this.selectionStart == '0') {
                        //For browsers like Firefox and Webkit based
                        var start = this.selectionStart;
                        var end = this.selectionEnd;
                        var scrollTop = this.scrollTop;
                        var search = this.value.substring(0, start);
                        search = search.lastIndexOf('@');
                        this.value = this.value.substring(0, search) + member + this.value.substring(end, this.value.length);
                        this.focus();
                        this.selectionStart = start + member.length;
                        this.selectionEnd = start + member.length;
                        this.scrollTop = scrollTop;
                    }
                }
            });
        } else {
            this.$el.find(".current-comment-box").each(function(i) {
                member = '@' + $(e.currentTarget).data('user-name');
                if (_.isUndefined(autoMentionSelectionStart) || parseInt(autoMentionSelectionStart) === 0) {
                    this.value = this.value + ' ' + member;
                    this.focus();
                } else {
                    if (document.selection) {
                        //For browsers like Internet Explorer
                        sel = document.selection.createRange();
                        sel.text = member;
                        this.focus();
                    } else if (this.selectionStart) {
                        //For browsers like Firefox and Webkit based
                        var start = this.selectionStart;
                        var end = this.selectionEnd;
                        var scrollTop = this.scrollTop;
                        var search = this.value.substring(0, start);
                        search = search.lastIndexOf('@');
                        this.value = this.value.substring(0, search) + member + this.value.substring(end, this.value.length);
                        this.focus();
                        this.selectionStart = start + member.length;
                        this.selectionEnd = start + member.length;
                    }
                }
            });
        }
        $(".js-comment").removeClass("current-comment-box");
        this.autoMentionSelectionStart = 0;
        this.$el.find('.js-search-member').val('').trigger('keyup');
    },
    renderBoardUsers: function() {
        var self = this;
        var view = this.$el.find('.js-organization-member-search-response');
        view.html('');
        this.model.list.collection.board.board_users.each(function(board_user) {
            var added_user = self.model.users.findWhere({
                card_id: self.model.id,
                user_id: board_user.attributes.user_id
            });
            var is_added_user = (!_.isUndefined(added_user)) ? true : false;
            view.append(new App.CardSearchUsersResultView({
                model: board_user,
                is_added_user: is_added_user,
                added_user: added_user,
                board: self.model.list.collection.board
            }).el);
        });
    },
    renderActivityBoardUsers: function() {
        var view = this.$el.find('.js-comment-member-search-response');
        this.model.list.collection.board.board_users.each(function(board_user) {
            $(new App.ActivityUserAddSearchResultView({
                model: board_user
            }).el).insertAfter(view);
        });
    },
    loadDropbox: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').addClass('open');
        if (typeof Dropbox == 'undefined') {
            $.ajax({
                cache: true,
                dataType: 'script',
                url: 'https://www.dropbox.com/static/api/2/dropins.js',
                success: function() {}
            });
        }
        if (target.hasClass('js-card-header-action')) {
            return false;
        }
    },
    /**
     * selectCardURL()
     * select card URL
     * @param e
     * @type Object(DOM event)
     *
     */
    selectCardURL: function(e) {
        $(e.target).select();
    },
    showActions: function(e) {
        this.$el.find('.js-new-comment').removeClass('hide');
    },
    noAction: function(e) {
        e.preventDefault();
        return false;
    },
    showSideCardTitleEditForm: function(e) {
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        return false;
    },
    openDropdown: function(e) {
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        return false;
    },
    onEnter: function(e) {
        if (e.which === 13) {
            var form = $(e.target).closest('form');
            if (form.attr('name') === 'cardAddForm') {
                $('input[type=submit]', form).trigger('click');
            } else {
                return false;
            }
        }
    },
    keyboardArchiveCard: function(e) {
        $('.js-archive-card', e.target).trigger('click');
        return false;
    },
    keyboardShowCardDueDateForm: function(e) {
        $('.docmodal-submenu').addClass('open');
        $('.dropdown-menu li:first-child').addClass('open');
        $('.js-show-card-due-date-form', e.target).trigger('click');
        return false;
    },
    keyboardShowCardTitleEditForm: function(e) {
        $('.js-show-card-title-edit-form', e.target).trigger('click');
        return false;
    },
    keyboardAddCardVote: function(e) {
        $('.js-add-card-vote', e.target).trigger('click');
        return false;
    },
    keyboardCardSubscribe: function(e) {
        if ($('.js-card-container .icon-eye-open', e.target).length) {
            $('.js-card-unsubscribe', e.target).trigger('click');
        } else {
            $('.js-card-subscribe', e.target).trigger('click');
        }
    },
    keyboardShowAddMemberForm: function(e) {
        $('.js-show-add-member-form', e.target).trigger('click');
        $('#js-card-user-add-container .js-member-dropdown').addClass('open');
        return false;
    },
    keyboardShowCardLabelForm: function(e) {
        $('.js-show-card-label-form').trigger('click');
        _(function() {
            $('#js-label-add-container .js-label-dropdown').addClass('open');
        }).defer();
        return false;
    },
    keyboardAddCardMember: function(e) {
        $('.js-show-add-member-form', e.target).trigger('click');
        _(function() {
            $('.dropdown-menu-left .js-organization-member-search-response', e.target).find('a').each(function(index, value) {
                if ($(value).data('user-id') == authuser.user.id) {
                    $(this).trigger('click');
                    $('#js-card-user-add-container .js-member-dropdown').removeClass('open');
                }
            });
        }).defer();
        return false;
    },
    cardActivityLoadMore: function(e) {
        var target = e.currentTarget;
        var page_no = $(target).data('attr');
        $('.js-remove-card-activity').remove();
        var self = this;
        self.model.activities = new App.ActivityCollection();
        var filter = $.cookie('filter');
        if (filter === undefined || filter === 'all') {
            filter = 'all';
        } else if (filter === 'comment') {
            filter = 'comment';
        } else if (filter === 'activity') {
            filter = 'activity';
        }
        self.model.activities.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/activities.json?mode=' + filter + '&page=' + page_no;
        self.model.activities.fetch({
            cache: false,
            success: function(model, response) {
                if (!_.isUndefined(response.data) && !_.isEmpty(response.data) && !_.isEmpty(response._metadata)) {
                    self.model.set('activity_count', response._metadata.total_records);
                    self.renderActivitiesCollection();
                } else {
                    $('#js-card-modal-' + this.model.id).find('.js-load-more-block').remove();
                }
            }
        });
        return false;
    },
});
