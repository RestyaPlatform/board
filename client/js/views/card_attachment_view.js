/**
 * @fileOverview This file has functions related to card attachment view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card attachment model. It contain all card based object @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardAttachment View
 * @class CardAttachmentView
 * @constructor
 * @extends Backbone.View
 */
App.CardAttachmentView = Backbone.View.extend({
    template: JST['templates/card_attachment'],
    initialize: function(options) {
        if (options.card_id) {
            this.card_id = options.card_id;
        }
        this.model.board = options.board;
        this.card = options.card;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
            this.model.downloadLink = this.downloadLink;
            this.model.documentLink = this.documentLink;
            this.model.videoLink = this.videoLink;
        }
    },
    tagName: 'li',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click a.js-show-confirm-delete-attachment': 'showConfirmAttachmentDelete',
        'click .js-close-popup': 'closePopup',
        'click .js-span-close-popup': 'closeSpanPopup',
        'click .js-delete-attachment': 'deleteAttachment',
        'click .js-attachment-make-cover': 'changeCover',
        'click .js-attachment-remove-cover': 'removeCover'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            attachment: this.model,
            card_id: this.card_id
        }));
        this.$el.attr('class', 'clearfix navbar-btn js-card-attachment-' + this.model.attributes.board_id + '-' + this.model.attributes.id);
        this.showTooltip();
        return this;
    },
    /**
     * deleteAttachment()
     * delete the attachment in card
     * @return false
     *
     */
    deleteAttachment: function() {
        this.$el.remove();
        var card = this.card;
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.attributes.card_id + '/attachments/' + this.model.id + '.json';
        this.model.destroy({
            success: function(model, response, options) {
                if (!_.isUndefined(response.activity)) {
                    var previous_attachment_count = card.attributes.attachment_count;
                    card.set('attachment_count', previous_attachment_count - 1);
                    response.activity = activityCommentReplace(response.activity);
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    var view_act = new App.ActivityView({
                        model: activity
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + parseInt(response.activity.card_id));
                    view_activity.prepend(view_act.render().el);
                }
            }
        });
        return false;
    },
    changeCover: function(e) {
        var card = this.card;
        var data = {};
        data.cover_image_id = this.model.id;
        var cardId = this.model.attributes.card_id;
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.attributes.card_id + '.json';
        this.model.save(data, {
            patch: true,
            success: function(model, response, options) {
                if (!_.isUndefined(response)) {
                    card.set('cover_image_id', data.cover_image_id);
                    var attachmentsList = $('#js-card-modal-' + cardId).find('#js-card-attachments-list');
                    $.each(attachmentsList.find('.js-cover-img-option'), function(i, attachment) {
                        if ($(attachment).attr('data-id') == data.cover_image_id) {
                            $(attachment).removeClass('js-attachment-make-cover').addClass('js-attachment-remove-cover');
                            $(attachment).html('<i class="icon-folder-close cur icon-light"></i>' + i18next.t('Remove Cover'));
                        } else if ($(attachment).hasClass('js-attachment-remove-cover')) {
                            $(attachment).removeClass('js-attachment-remove-cover').addClass('js-attachment-make-cover');
                            $(attachment).html('<i class="icon-folder-close cur icon-light"></i>' + i18next.t('Make Cover'));
                        }
                    });
                    if (!_.isUndefined(response.activity)) {
                        response.activity = activityCommentReplace(response.activity);
                        var activity = new App.Activity();
                        activity.set(response.activity);
                        var view_act = new App.ActivityView({
                            model: activity
                        });
                        self.model.activities.unshift(activity);
                        var view_activity = $('#js-card-activities-' + parseInt(response.activity.card_id));
                        view_activity.prepend(view_act.render().el);
                    }
                }
            }
        });
    },
    removeCover: function(e) {
        var card = this.card;
        var data = {};
        data.cover_image_id = 0;
        var cardId = this.model.attributes.card_id;
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.attributes.card_id + '.json';
        this.model.save(data, {
            patch: true,
            success: function(model, response, options) {
                if (!_.isUndefined(response)) {
                    card.set('cover_image_id', 0);
                    var attachmentsList = $('#js-card-modal-' + cardId).find('#js-card-attachments-list');
                    $.each(attachmentsList.find('.js-cover-img-option'), function(i, attachment) {
                        if ($(attachment).hasClass('js-attachment-remove-cover')) {
                            $(attachment).removeClass('js-attachment-remove-cover').addClass('js-attachment-make-cover');
                            $(attachment).html('<i class="icon-folder-close cur icon-light"></i>' + i18next.t('Make Cover'));
                        }
                    });
                    if (!_.isUndefined(response.activity)) {
                        response.activity = activityCommentReplace(response.activity);
                        var activity = new App.Activity();
                        activity.set(response.activity);
                        var view_act = new App.ActivityView({
                            model: activity
                        });
                        self.model.activities.unshift(activity);
                        var view_activity = $('#js-card-activities-' + parseInt(response.activity.card_id));
                        view_activity.prepend(view_act.render().el);
                    }
                }
            }
        });
    },
    /**
     * showConfirmAttachmentDelete()
     * display attachment delete confirmation form
     * @param e
     * @type Object(DOM event)
     *
     */
    showConfirmAttachmentDelete: function(e) {
        e.preventDefault();
        $('.js-attachment-confirm-respons-' + this.model.id, this.$el).html(new App.AttachmentDeleteConfirmView({
            model: this.model
        }).el);
    },
    /**
     * closePopup()
     * hide opend dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    },
    closeSpanPopup: function(e) {
        var target = $(e.target);
        target.parents('.dropdown').removeClass('open');
        return false;
    }
});
