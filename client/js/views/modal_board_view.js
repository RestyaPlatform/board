/**
 * @fileOverview This file has functions related to modal board view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ModalBoard View
 * @class ModalBoardView
 * @constructor
 * @extends Backbone.View
 */
App.ModalBoardView = Backbone.View.extend({
    id: 'base-modal',
    className: '',
    template: JST['templates/modal_list_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.model.attachments.bind('remove', this.displayEmptyMessage, this);
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
            list: this.model
        }));
        this.renderAttachmentsCollection();
        this.$el.modal({
            show: true,
            backdrop: false
        });
        this.showTooltip();
        return this;
    },
    /**
     * show()
     * display list attachment in modal box
     *
     */
    show: function() {
        this.render();
        this.$el.find('#modalListView').modal('show');
    },
    /**
     * closePopup()
     * hide displayed dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    },
    /**
     * renderAttachmentsCollection()
     * display attachments in list
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    renderAttachmentsCollection: function() {
        var view_attachment = this.$('#js-list-attachments-list');
        view_attachment.html('');
        var attachments = this.model.attachments;
        var attachments_length = attachments.models.length;
        if (attachments_length > 0) {
            for (var attachments_i = 0; attachments_i < attachments_length; attachments_i++) {
                var attachment = attachments.models[attachments_i];
                var view = new App.AttachmentView({
                    model: attachment,
                    board: this.model
                });
                view_attachment.append(view.render().el);
            }
            view_attachment.find('.timeago').timeago();
        } else {
            var empty_view = new App.AttachmentView({
                model: null
            });
            view_attachment.append(empty_view.render().el);
        }
    },
    displayEmptyMessage: function() {
        if (this.model.attachments.length === 0) {
            var view_attachment = this.$('#js-list-attachments-list');
            var view = new App.AttachmentView({
                model: null
            });
            view_attachment.html(view.render().el);
        }
    }
});
