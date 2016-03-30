/**
 * @fileOverview This file has functions related to attachment delete confirm view. This view calling from modal board and modal list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: attachment model and it's related values
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Flickr View
 * @class FlickrView
 * @constructor
 * @extends Backbone.View
 */
App.FlickrView = Backbone.View.extend({
    template: JST['templates/flickr'],
    tagName: 'li',
    className: 'clearfix navbar-btn',
    initialize: function() {
        this.render();
    },
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click a.js-show-confirm-delete-attachment': 'showConfirmAttachmentDelete',
        'click .js-close-popup': 'closePopup',
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
            photo: this.model
        }));
        this.showTooltip();
        return this;
    },
    /**
     * deleteAttachment()
     * delete the attachment
     * @param NULL
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
     * show the confirm attachment delete
     * @param e
     * @type Object(DOM event)
     */
    showConfirmAttachmentDelete: function(e) {
        e.preventDefault();
        $('.js-attachment-confirm-respons-' + this.model.id, this.$el).html(new App.AttachmentDeleteConfirmFormView({
            model: this.model
        }).el);
    },
    /**
     * closePopup()
     * close the opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    }
});
