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
        this.model.board = options.board;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
            this.model.downloadLink = this.downloadLink;
        }
    },
    tagName: 'li',
    className: 'clearfix navbar-btn',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click a.js-show-confirm-delete-attachment': 'showConfirmAttachmentDelete',
        'click .js-close-popup': 'closePopup',
        'click .js-span-close-popup': 'closeSpanPopup',
        'click .js-delete-attachment': 'deleteAttachment'
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
            attachment: this.model
        }));
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
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.list_id + '/cards/' + this.model.attributes.card_id + '/attachments/' + this.model.id + '.json';
        this.model.destroy();
        return false;
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
