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
 *	this.model.list  				: list model(Based on card). It contain all list based object @see Available Object in App.ListView
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
    converter: new showdown.Converter(),
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
        'click .js-cancel-card-description-edit': 'cancelCardDescEditForm',
        'click .js-show-card-due-date-form': 'showCardDueDateForm',
        'click .js-edit-card-due-date-form': 'editCardDueDateForm',
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
        _.bindAll(this, 'render', 'renderChecklistsCollection', 'renderUsersCollection', 'refreshdock');
        this.model.bind('change:name change:description change:board_id  change:cards_checklists  change:cards_labels  change:cards_subscribers  change:is_archived  change:due_date change:list_id  change:title', this.refreshdock);
        this.model.cards_subscribers.bind('add remove', this.refreshdock);
        this.model.checklists.bind('remove', this.renderChecklistsCollection);
        this.model.checklists.bind('add', this.renderChecklistsCollection);
        this.model.checklists.bind('change:name', this.renderChecklistsCollection);
        this.model.list.collection.board.checklist_items.bind('add', this.renderChecklistsCollection);
        this.model.list.collection.board.checklist_items.bind('remove', this.renderChecklistsCollection);
        this.model.list.collection.board.cards.bind('change:list_id', this.refreshdock);
        self.authuser = authuser.user;
        this.model.card_voters.bind('add', this.refreshdock);
        this.model.card_voters.bind('remove', this.refreshdock);
        this.model.attachments.bind('add', this.refreshdock);
        this.model.attachments.bind('remove', this.refreshdock);
        this.board = self.model.list.collection.board;
        _(this).bindAll('show');
        this.boards = new App.BoardCollection();
        if (!_.isUndefined(authuser.user)) {
            this.boards.url = api_url + 'users/' + authuser.user.id + '/boards.json?type=simple';
            this.boards.fetch();

        }
        this.boards = App.boards;
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
        this.$el.find('.js-comment').val(this.$el.find('.js-comment').val() + ':' + target.text() + ': ');
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
        var i = 0;
        var hide_class = '';
        var target = $(e.currentTarget);
        var e_target = $(e.target).parents().find('#card_activities');
        if (!$('#' + target.attr('id'), e_target).parent('ul').hasClass('called')) {
            $('#' + target.attr('id'), e_target).parent('ul').addClass('called');
            $('#' + target.attr('id'), e_target).toggleClass('active');
            if (!$('#modal-comments', e_target).hasClass('active')) {
                i++;
                hide_class = hide_class + '.modal-comments, ';
            }
            if (!$('#modal-activities', e_target).hasClass('active')) {
                i++;
                hide_class = hide_class + '.modal-activities, ';
            }
            hide_class = hide_class.substring(0, hide_class.lastIndexOf(', '));
            if (i === 2 || i === 0) {
                $('.modal-comments, .modal-activities', e_target).parent('li').removeClass('hide');
            }
            if (i !== 2) {
                $(hide_class, e_target).parent('li').addClass('hide');
            }
            $('#' + target.attr('id'), e_target).parent('ul').removeClass('called');
        }
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
        var compareList = oldLabelList.localeCompare(newLabelList);
        if (compareList !== 0) {
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
                            board: self.model.list.collection.board
                        });
                        self.model.activities.unshift(activity);
                        var view_activity = $('#js-card-activities-' + self.model.id);
                        view_activity.prepend(view.render().el).find('.timeago').timeago();
                        emojify.run();
                    }
                }
            });
        }
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
            tags: _.uniq(self.model.list.collection.board.labels.pluck('name')),
            tokenSeparators: [',', ' ']
        });
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('li.dropdown').addClass('open');
        if (target.hasClass('js-card-header-action')) {
            return false;
        }
    },
    /**
     * editCardDueDateForm()
     * update card due date
     * @param e
     * @type Object(DOM event)
     */
    editCardDueDateForm: function(e) {
        $('.js-edit-card-due-date-form-response').html(new App.CardDuedateFromView({
            model: this.model
        }).el);
        $('.js-card-duedate-edit-' + this.model.id).datetimepicker({
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: 'bottom-right',
            todayHighlight: 1,
            startView: 2,
            minView: 2,
            bootcssVer: 3,
            pickTime: false
        });
        $('.js-card-duetime-edit-' + this.model.id).datetimepicker({
            format: 'hh:ii:ss',
            autoclose: true,
            showMeridian: false,
            startView: 1,
            maxView: 1,
            pickDate: false,
            use24hours: true
        });
    },
    /**
     * showCardDueDateForm()
     * display card due date form
     * @param e
     * @type Object(DOM event)
     */
    showCardDueDateForm: function(e) {
        $('.js-show-card-due-date-form-response').html('').html(new App.CardDuedateFromView({
            model: this.model
        }).el);
        $('.js-card-duedate-edit-' + this.model.id).datetimepicker({
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: 'bottom-right',
            todayHighlight: 1,
            startView: 2,
            minView: 2,
            bootcssVer: 2,
            pickTime: false
        }).on('changeDate', function(ev) {
            $(this).datetimepicker('hide');
            $(this).blur();
        });
        $('.js-card-duetime-edit-' + this.model.id).datetimepicker({
            format: 'hh:ii:ss',
            autoclose: true,
            showMeridian: false,
            startView: 1,
            maxView: 1,
            pickDate: false,
            use24hours: true
        }).on('changeDate', function(ev) {
            $(this).datetimepicker('hide');
            $(this).blur();
        });
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
        this.$el.find('.js-show-card-desc').next('p').show();
        this.$el.find('#cardDescriptionEditForm').hide();
        return false;
    },
    /**
     * showMemberSearch()
     * Show member search form and search members
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    showMemberSearch: function(e) {
        var q = $(e.target).val();
        var keyCode = e.which || e.keyCode;
        if (keyCode === 50 && (e.shiftKey || e.metaKey)) {
            this.autoMentionSelectionStart = e.target.selectionStart;
            $('.js-show-members').parents('.dropdown:first').addClass('open');
        } else if (this.autoMentionSelectionStart) {
            if (keyCode == 32) {
                this.autoMentionSelectionStart = 0;
                $('.js-show-members').parents('.dropdown:first').removeClass('open');
            } else {
                var regex = / /gi,
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
                $('.js-search-member').val(q.substr(this.autoMentionSelectionStart, indice - this.autoMentionSelectionStart)).trigger('keyup');
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
        this.$el.find('.js-show-card-desc').next('p').hide();
        this.$el.find('#cardDescriptionEditForm').removeClass('hide').show();
        return false;
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
        if (!_.isUndefined(data.due_date) || !_.isUndefined(data.due_time)) {
            data = {
                to_date: data.due_date,
                due_date: data.due_date + ' ' + data.due_time,
                start: data.due_date + 'T' + data.due_time
            };
        }
        this.model.set(data);
        var target = $(e.currentTarget);
        $('.js-show-side-card-title-edit-form').parents().find('.dropdown').removeClass('open');
        if (!_.isUndefined(data.name)) {
            target.prev('h4').html(_.escape(data.name)).removeClass('hide');
        }
        if (!_.isUndefined(data.description)) {
            if (!$.trim($('#inputCarddescription').val()).length) {
                $('.error-msg').remove();
                $('<div class="error-msg text-primary h6">Whitespace alone not allowed</div>').insertAfter('#inputCarddescription');
                validation = false;
                this.$el.find('#cardDescriptionEditForm').removeClass('hide').show();
            } else {
                $('.error-msg').remove();
                $('.js-show-card-desc').show();
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
                                board: self.model.list.collection.board
                            });
                            self.model.activities.unshift(activity, {
                                silent: true
                            });
                            var view_activity = $('#js-card-activities-' + self.model.id);
                            view_activity.prepend(view.render().el).find('.timeago').timeago();
                            emojify.run();
                        }
                        self.model.cards.add(self.model);
                    }
                    if (!_.isEmpty(data.due_date)) {
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
        this.render();
        var self = this;
        self.model.activities = new App.ActivityCollection();
        self.model.activities.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.attributes.list_id + '/cards/' + self.model.id + '/activities.json';
        self.model.activities.fetch({
            success: function(model, response) {
                self.renderActivitiesCollection();
            }
        });
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
            $('.title-text', doc.parent().prev('.dockmodal-header')).html('<div class="card-id pull-left"><strong>#' + this.model.id + '</strong></div><span class="title-color' + class_name + '" id="js-title-color-' + this.model.id + '">' + text + '</span>');
            doc.html(this.template({
                card: this.model,
                checklist_lists: this.checklist_list,
                converter: this.converter,
                list: this.model.list
            })).dockmodal('refreshLayout');
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
                });
                var dragging = 0;
                $('#dropzone' + self.model.id).on('dragenter', function(e) {
                    dragging++;

                });
                $('#dropzone' + self.model.id).on('dragleave', function(e) {
                    dragging--;
                    if (dragging === 0 || !$.browser.chrome) {
                        $('#js-card-modal-' + self.model.id).removeClass('drophover');
                    }
                });
                uploadManager.on('fileuploaddrop', function(e) {
                    dragging--;
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
                        self.model.list.collection.board.attachments.unshift(attachment, options);
                        i++;
                    });
                });
            }).defer();
            this.resizeSplitter();
            this.renderAttachmentsCollection();
            this.renderLabelsCollection();
            this.renderUsersCollection();
            this.renderActivitiesCollection();
            this.renderChecklistsCollection();
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
        if (doc.length === 0) {
            $('.js-hidden-blocks').append(this.$el.html(this.template({
                card: this.model,
                checklist_lists: this.checklist_list,
                converter: this.converter,
                list: this.model.list
            })).attr('id', 'js-card-modal-' + this.model.id));
            this.renderAttachmentsCollection();
            this.renderLabelsCollection();
            this.renderUsersCollection();
            this.renderChecklistsCollection();
            var title = i18next.t('%s in list %s %s', {
                postProcess: 'sprintf',
                sprintf: [_.escape(this.model.attributes.name), _.escape(this.model.list.attributes.name), subscribed]
            });
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
                title: '<div class="card-id pull-left"><strong>#' + this.model.id + '</strong></div><span class="title-color' + class_name + '" id="js-title-color-' + this.model.id + '">' + title + '</span>',
                beforePopout: function(event) {
                    if (!_.isUndefined(authuser.user)) {
                        $('#js-title-color-' + self.model.id).parent('.title-text').css('margin-left', '34px');
                    }
                    $('.editor').resizable({
                        maxWidth: 900
                    });
                },
                beforeRestore: function(event) {
                    if (!_.isUndefined(authuser.user)) {
                        $('#js-title-color-' + self.model.id).parent('.title-text').css('margin-left', '34px');
                    }
                    $('.editor').resizable({
                        maxWidth: 490
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
                },
                close: function(event, dialog) {
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
                        } else {
                            current_param = 'board/' + self.model.attributes.board_id;
                        }
                        app.navigate('#/' + current_param, {
                            trigger: false,
                            trigger_function: false,
                        });
                        event.remove();
                    }
                }
            });
        } else {
            doc.dockmodal('restore');
        }
        this.$el.find('.js-organization-member-search-response').html('');
        this.renderBoardUsers();
        this.$el.find('.js-comment-member-search-response').nextAll().remove();
        this.renderActivityBoardUsers();
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
            });
            var dragging = 0;
            $('#dropzone' + self.model.id).on('dragenter', function(e) {
                dragging++;
            });
            $('#dropzone' + self.model.id).on('dragleave', function(e) {
                dragging--;
                if (dragging === 0 || !$.browser.chrome) {
                    $('#js-card-modal-' + self.model.id).removeClass('drophover');
                }
            });
            uploadManager.on('fileuploaddrop', function(e) {
                dragging--;
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
                    self.model.list.collection.board.attachments.unshift(attachment, options);
                    i++;
                });
            });
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
            var factor1 = window.sessionStorage.getItem('factor1');
            if (factor1 === null) {
                factor1 = '20';
                factor2 = '80';
            } else {
                factor2 = 100 - factor1;
            }
            $this.resizable({
                handles: 'e',
                minWidth: 110,
                maxWidth: 490,
                resize: function(event, ui) {
                    var x = ui.element.outerWidth();
                    var ele = ui.element;
                    var factor = x * 100 / $(this).parent().width();
                    var f1 = factor;
                    var f2 = 100 - factor;
                    window.sessionStorage.setItem('factor1', f1);
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
        self.model.card_voters.add(card_voter);
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
                self.model.list.collection.board.cards.get(self.model.id).card_voters.add(card_voter);
                self.model.set('card_voter_count', parseInt(self.model.attributes.card_voter_count) + 1);
                if (!_.isUndefined(response.activity)) {
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view.render().el).find('.timeago').timeago();
                    emojify.run();
                }
            }
        });
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
        card_voter.destroy({
            success: function(model, response) {
                if (!_.isUndefined(response.activity)) {
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view.render().el).find('.timeago').timeago();
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
                if (_.isUndefined(options.temp_id)) {
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
        var card_id = this.model.id;
        var current_card = this.model.attributes;
        var data = $(e.target).serializeObject();
        data.list_id = parseInt(data.list_id);
        data.board_id = parseInt(data.board_id);
        var position = parseInt(data.position);
        var prev_list_id = this.model.attributes.list_id;
        var prev_board_id = this.model.attributes.board_id;
        var view_card = $('#js-card-listing-' + data.list_id);
        if (data.list_id !== this.model.attributes.list_id) {
            var card_count = parseInt(this.boards.get(this.model.attributes.board_id).lists.get(this.model.attributes.list_id).get('card_count'));
            this.boards.get(this.model.attributes.board_id).lists.get(this.model.attributes.list_id).set('card_count', card_count - 1);
        }
        var cards = this.model.list.collection.board.cards.where({
            list_id: data.list_id
        });
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.id + '.json';
        var list_cards = new App.CardCollection();
        list_cards.add(cards);
        list_cards.sortByColumn('position');
        var next = view_card.find('.js-board-list-card:nth-child(' + data.position + ')');
        var prev = view_card.find('.js-board-list-card:nth-child(' + (data.position - 1) + ')');
        var before = '';
        var after = '';
        var difference = '';
        var newPosition = '';
        var view = '';
        var list = this.board.lists.findWhere({
            id: data.list_id
        });
        this.model.set(data, {
            silent: true
        });
        if (!_.isUndefined(list)) {
            this.model.list = list;
        }
        if (prev.length !== 0) {
            before = list_cards.get(parseInt(prev.data('card_id')));
            after = list_cards.at(list_cards.indexOf(before) + 1);
            if (typeof after == 'undefined') {
                afterPosition = before.position() + 2;
            } else {
                afterPosition = after.position();
            }
            difference = (afterPosition - before.position()) / 2;
            newPosition = difference + before.position();
            this.model.set({
                position: newPosition
            });
            data.position = newPosition;
            view = new App.CardView({
                tagName: 'div',
                model: this.model,
                converter: this.converter
            });
            prev.after(view.render().el);
        } else if (next.length !== 0) {
            after = list_cards.get(parseInt(next.data('card_id')));
            before = list_cards.at(list_cards.indexOf(after) - 1);
            if (typeof before == 'undefined') {
                beforePosition = 0.0;
            } else {
                beforePosition = before.position();
            }
            difference = (after.position() - beforePosition) / 2;
            newPosition = difference + beforePosition;
            this.model.set({
                position: newPosition
            });
            data.position = newPosition;
            view = new App.CardView({
                tagName: 'div',
                model: this.model,
                converter: this.converter
            });
            next.before(view.render().el);
        } else {
            view = new App.CardView({
                tagName: 'div',
                model: this.model,
                converter: this.converter
            });
            view_card.append(view.render().el);
            data.position = position;
        }
        if (data.board_id !== prev_board_id) {
            this.boards.get(data.board_id).lists.get(data.list_id).set('card_count', list_cards.length + 1);
            this.model.collection.remove(this.model, {
                silent: true
            });
            var close_doc = $('#js-card-modal-' + this.model.id);
            close_doc.dockmodal('close');
            $('#js-card-' + this.model.id).remove();
        } else {
            if (data.list_id !== prev_list_id) {
                this.boards.get(list.attributes.board_id).lists.get(list.attributes.id).set('card_count', list_cards.length + 1);
            } else {
                this.boards.get(list.attributes.board_id).lists.get(list.attributes.id).set('card_count', list_cards.length);
            }
            list.set('card_count', list_cards.length + 1);
            this.model.set(data);
            this.refreshdock();
        }
        if (data.list_id !== current_card.list_id) {
            this.$el.modal('hide');
            this.model.collection.remove(this.model);
            data.board_id = parseInt(data.board_id);
            if (data.board_id === current_card.board_id) {
                this.model.list.collection.board.cards.remove(this.model);
                this.model.list.collection.board.lists.get(parseInt(data.list_id)).cards.add(this.model);
                this.model.list = this.model.list.collection.get(parseInt(data.list_id));
                var doc = $('#js-card-modal-' + this.model.id);
                doc.dockmodal('close');
            }
            this.model.set(data);
        }
        this.model.list.cards.sortByColumn('position');

        this.model.save(data, {
            patch: true
        });
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
                    self.model.set('is_offline', false);
                }
                if (!_.isUndefined(self.model.id) && _.isUndefined(options.temp_id)) {
                    self.model.set({
                        id: parseInt(self.model.id)
                    });
                } else {
                    global_uuid[uuid] = options.temp_id;
                    self.model.set('id', uuid);
                }
                var activity = new App.Activity();
                activity.set(response.activity);
                activity.board_users = self.model.board_users;
                var view = new App.ActivityView({
                    model: activity,
                    board: self.model.list.collection.board
                });
                model.set('activities', activity);
                var view_activity = $('#js-card-activities-' + self.model.id);
                view_activity.prepend(view.render().el).find('.timeago').timeago();
                emojify.run();
                var list = App.boards.get(self.model.attributes.board_id).lists.get(self.model.attributes.list_id);
                if (!_.isUndefined(list)) {
                    list.set('card_count', list.attributes.card_count - 1);
                }
            }
        });
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
        this.model.save({
            is_archived: 0
        }, {
            patch: true,
            success: function(model, response, options) {
                if (_.isUndefined(options.temp_id)) {
                    self.model.set('is_offline', false);
                }
                if (!_.isUndefined(self.model.id) && _.isUndefined(options.temp_id)) {
                    self.model.set({
                        id: parseInt(self.model.id)
                    });
                } else {
                    global_uuid[uuid] = options.temp_id;
                    self.model.set('id', uuid);
                }
                var activity = new App.Activity();
                activity.set(response.activity);
                activity.board_users = self.model.board_users;
                var view = new App.ActivityView({
                    model: activity,
                    board: self.model.list.collection.board
                });
                model.set('activities', activity);
                var view_activity = $('#js-card-activities-' + self.model.id);
                view_activity.prepend(view.render().el).find('.timeago').timeago();
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
        $(form).append('<input type="file" name="attachment[]" class="js-card-attachment" multiple>');
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
                                self.model.list.collection.board.attachments.unshift(attachment, options);
                                i++;
                            });

                            var view_attachment = self.$('#js-card-attachments-list');
                            view_attachment.find('.timeago').timeago();
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
                        self.model.list.collection.board.attachments.unshift(attachment, options);
                        i++;
                    });
                    var view_attachment = this.$('#js-card-attachments-list');
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view_act = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view_act.render().el).find('.timeago').timeago();
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
            var view = new App.CardAttachmentView({
                model: attachment,
                board: self.model.list.collection.board
            });
            view_attachment.append(view.render().el).find('.timeago').timeago();
            emojify.run();
        });
    },
    /**
     * renderLabelsCollection()
     * display labels in card
     */
    renderLabelsCollection: function() {
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
    },
    /**
     * renderActivitiesCollection()
     * display card activities
     */
    renderActivitiesCollection: function() {
        if (this.model.list.collection.board.attributes.board_visibility === 2 || (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.list.collection.board.acl_links.where({
                slug: "view_card_activities",
                board_user_role_id: parseInt(this.model.board_user_role_id)
            }))))) {
            var self = this;
            var view_activity = this.$('#js-card-activities-' + self.model.id);
            view_activity.html('');
            if (!_.isEmpty(this.model.activities)) {
                this.model.activities.each(function(activity) {
                    $('#js-loader-img').removeClass('hide');
                    if (!_.isEmpty(self.model.collection)) {
                        activity.cards.add(self.model.collection.models);
                    }
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board
                    });
                    view_activity.append(view.render().el).find('.timeago').timeago();
                    $('#js-loader-img').addClass('hide');
                });
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
        this.renderBoardUsers();
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
                content += '<li class="js-added-card-user-' + user.attributes.user_id + '"><a href="#/user/' + user.attributes.user_id + '">' + content_img + '</a></li>';
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
        target.parents('div.dropdown').removeClass('open');
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
                        board: self.model.list.collection.board
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view_act.render().el).find('.timeago').timeago();
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
        $('.js-member-dropdown').removeClass('open');
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
                        board: self.model.list.collection.board
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view.render().el).find('.timeago').timeago();
                }
                self.renderUsersCollection();
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
        e.preventDefault();
        if (!$.trim($(e.target).find('#inputAddComment').val()).length) {
            $(e.target).find('.error-msg').remove();
            $('<div class="error-msg text-primary h6">Whitespace alone not allowed</div>').insertAfter($(e.target).find('#inputAddComment'));
        } else {
            $(e.target).find('.error-msg').remove();
            var self = this;
            $('.js-add-comment-response').html('<span class="js-show-add-comment-form cur">' + i18next.t('Add Comment') + '</span>');
            var board_id = this.model.attributes.board_id;
            var data = $(e.target).serializeObject();
            var is_reply = $(e.target).hasClass('js-reply-form');
            if (!is_reply) {
                $(e.target)[0].reset();
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
                        activity.set('depth', response.activities.depth);
                    }

                    model.set('type', 'add_comment');
                    activity.set('username', authuser.user.username);
                    activity.set('profile_picture_path', authuser.user.profile_picture_path);
                    activity.set('initials', authuser.user.initials);
                    self.model.activities.unshift(activity);
                    self.model.list.collection.board.activities.add(activity);
                    model.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: model,
                        board: self.model.list.collection.board
                    });
                    self.model.activities.unshift(activity);
                    var current_card = self.model.list.collection.board.cards.get(self.model.id);
                    self.model.list.collection.board.cards.get(self.model.id).set('comment_count', parseInt(current_card.attributes.comment_count) + 1);
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    if (!_.isEmpty(data.root)) {
                        $(view.render().el).insertAfter($('.js-list-activity-' + data.root)).find('.timeago').timeago();
                    } else {
                        view_activity.prepend(view.render().el).find('.timeago').timeago();
                    }
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
        var activity_id = $(e.target).data('activity-id');
        var temp_id = $(e.target).data('activity-temp-id');
        $('.js-acticity-action-' + activity_id).addClass('hide');
        var activitiy = this.model.activities.get({
            id: activity_id
        });
        activitiy.board_user_role_id = this.model.board_user_role_id;
        activitiy.board = this.model.board;
        $('.js-list-activity-' + activity_id).addClass('edit-comment');
        $('.js-activity-' + activity_id).html(new App.EditActivityFormView({
            model: activitiy,
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
            $('<div class="error-msg text-primary h6">' + i18next.t('Whitespace alone not allowed') + '</div>').insertAfter('.js-inputComment');
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
            $('.js-activity-' + activity_id).html(this.converter.makeHtml(data.comment));
            $('.js-acticity-action-' + activity_id).removeClass('hide');
            //Update in list table
            var activity = new App.Activity();
            activity.id = parseInt(activity_id);
            activity.set('is_offline', true);
            activity.set('temp_id', temp_id);
            activity.url = api_url + 'boards/' + board_id + '/lists/' + list_id + '/cards/' + card_id + '/comments/' + activity_id + '.json';
            activity.save(data, {
                success: function(model, response) {
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    activity.board_users = self.model.board_users;
                    var view = new App.ActivityView({
                        model: activity,
                        board: self.model.list.collection.board
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view.render().el).find('.timeago').timeago();
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
        this.$el.find('.js-hide-edit-comment-form').parents('span.js-activity-' + activity_id).html(this.converter.makeHtml(_.escape(current_card.attributes.comment)));
        $('.js-acticity-action-' + activity_id).removeClass('hide');
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
                    board: self.model.list.collection.board
                });
                self.model.activities.unshift(activity);
                var current_card = self.model.list.collection.board.cards.get(card_id);
                self.model.list.collection.board.cards.get(card_id).set('comment_count', parseInt(current_card.attributes.comment_count) - 1);
                var view_activity = $('#js-card-activities-' + self.model.id);
                view_activity.prepend(view.render().el).find('.timeago').timeago();
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
                    view_attachment.append(view.render().el).find('.timeago').timeago();
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
                        board: self.model.list.collection.board
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + self.model.id);
                    view_activity.prepend(view.render().el).find('.timeago').timeago();
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
    showSearchCards: function() {
        var self = this;
        var q = this.$el.find('.js-search-card').val();
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
        this.$el.find('.js-comment').val(this.$el.find('.js-comment').val() + '#' + card_id + ' ');
    },
    /**
     * changeList()
     * change list based on selected board
     * @param string
     * @type string
     */
    changeList: function(e) {
        var target = $(e.currentTarget);
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
            _.each(board_lists, function(list) {
                if (self.model.attributes.list_id == list.attributes.id) {
                    content_list += '<option value="' + list.id + '" selected="selected">' + _.escape(list.attributes.name) + ' ' + i18next.t('(current)') + '</option>';
                    is_first_list = true;
                } else {
                    content_list += '<option value="' + list.id + '">' + _.escape(list.attributes.name) + '</option>';
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
                    self.model.list.collection.board.checklists.add(response.cards.cards_checklists);
                    self.model.list.collection.board.labels.add(response.cards.cards_labels);
                }
                var activity = new App.Activity();
                activity.set(response.activity);
                activity.board_users = self.model.board_users;
                var view = new App.ActivityView({
                    model: activity,
                    board: self.model.list.collection.board
                });
                self.model.activities.unshift(activity);
                var view_activity = $('#js-card-activities-' + self.model.id);
                view_activity.prepend(view.render().el).find('.timeago').timeago();
            }
        });

    },
    /**
     * showSearchMembers()
     * display searched member list
     */
    showSearchMembers: function(e) {
        var self = this;
        var q = $(e.target).val();
        if (q !== '') {
            var filtered_users = this.model.list.collection.board.board_users.search(q);
            var users = new App.UserCollection();
            if (!_.isEmpty(filtered_users._wrapped)) {
                $.unique(filtered_users._wrapped);
            }
            users.add(filtered_users._wrapped);
            this.$el.find('.js-comment-member-search-response').nextAll().remove();
            if (!_.isEmpty(users.models)) {
                _.each(users.models, function(user) {
                    $(new App.ActivityUserAddSearchResultView({
                        model: user
                    }).el).insertAfter(self.$el.find('.js-comment-member-search-response'));
                });
                if (users.models.length === 0) {
                    $(new App.ActivityUserAddSearchResultView({
                        model: null
                    }).el).insertAfter(self.$el.find('.js-comment-member-search-response'));
                }
            } else {
                $(new App.ActivityUserAddSearchResultView({
                    model: null
                }).el).insertAfter(self.$el.find('.js-comment-member-search-response'));
            }
        } else {
            this.$el.find('.js-comment-member-search-response').nextAll().remove();
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
        if (_.isEmpty($('.js-search-member').val())) {
            var space = _.isEmpty(this.$el.find('.js-comment').val()) ? '' : ' ';
            this.$el.find('.js-comment').val(this.$el.find('.js-comment').val() + space + '@' + $(e.currentTarget).data('user-name')).focus();
        } else {
            this.$el.find('.js-comment').val(this.$el.find('.js-comment').val().replace('@' + $('.js-search-member').val(), '@' + $(e.currentTarget).data('user-name'))).focus();
        }
        this.autoMentionSelectionStart = 0;
        $('.js-search-member').val('').trigger('keyup');
    },
    renderBoardUsers: function() {
        var self = this;
        var view = this.$el.find('.js-organization-member-search-response');
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
        return false;
    },
    keyboardShowCardLabelForm: function(e) {
        $('.js-show-card-label-form', e.target).trigger('click');
        return false;
    },
    keyboardAddCardMember: function(e) {
        $('.dropdown-menu-left .js-organization-member-search-response', e.target).find("a").each(function(index, value) {
            if ($(value).data('user-id') == authuser.user.id) {
                $(this).trigger('click');
            }
        });
        return false;
    },
});
