/**
 * @fileOverview This file has functions related to modal list view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list model. @see Available Object in App.ListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ModalList View
 * @class ModalListView
 * @constructor
 * @extends Backbone.View
 */
App.ModalListView = Backbone.View.extend({
    id: 'base-modal',
    className: '',
    template: JST['templates/modal_list_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'hidden': 'teardown',
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
        _(this).bindAll('show', 'teardown');
    },
    teardown: function() {
        this.$el.data('modal', null);
        this.remove();
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
     * display list attachment
     */
    show: function() {
        this.render();
        this.$el.find('#modalListView').modal('show');
    },
    /**
     * closePopup()
     * close opened dropdown
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
     * render attachments
     */
    renderAttachmentsCollection: function() {
        var view_attachment = this.$('#js-list-attachments-list');
        view_attachment.html('');
        var attachments = this.model.collection.board.attachments.where({
            list_id: this.model.id
        });
        var self = this;
        var filtered_attachments = new App.AttachmentCollection();
        filtered_attachments.reset(attachments);
        if (filtered_attachments.length > 0) {
            filtered_attachments.each(function(attachment) {
                var view = new App.AttachmentView({
                    model: attachment,
                    board: self.model.board
                });
                view_attachment.append(view.render().el).find('.timeago').timeago();
            });
        } else {
            var view = new App.AttachmentView({
                model: null
            });
            view_attachment.append(view.render().el);
        }
    }
});
