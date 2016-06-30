/**
 * @fileOverview This file has functions related to modal card member form view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board users collection.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ModalCardMemberForm View
 * @class ModalCardMemberFormView
 * @constructor
 * @extends Backbone.View
 */
App.ModalCardMemberFormView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.users = options.users;
        this.card = options.card;
        this.render();
    },
    template: JST['templates/modal_card_member_form'],
    tagName: 'div',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({
            board_users: this.model,
            users: this.users,
            card: this.card,
        });

        this.showTooltip();
        return this;
    }
});
