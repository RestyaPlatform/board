/**
 * @fileOverview This file has functions related to archived card view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model and it's related values. It contain all card based object @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ArchivedCard View
 * @class ArchivedCardView
 * @constructor
 * @extends Backbone.View
 */
App.ArchivedCardView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
            var board_user_role_id = this.model.board_users.findWhere({
                user_id: parseInt(authuser.user.id)
            });
            if (!_.isEmpty(board_user_role_id)) {
                this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
            }
        }
        this.render();
    },
    template: JST['templates/archived_card'],
    tagName: 'li',
    className: 'list-group-item clearfix',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete-archived-card-confirm': 'deleteArchivedCardConfirm',
        'click .js-show-modal-card-view': 'showCardModal'
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
        e.preventDefault();
        var self = this;
        trigger_dockmodal = true;
        var card = self.model.board.cards.findWhere({
            id: parseInt(self.model.id)
        });
        if (!_.isUndefined(card)) {
            card.list = self.model.board.lists.findWhere({
                id: card.attributes.list_id
            });
            var filter_labels = self.model.board.labels.filter(function(model) {
                return parseInt(model.get('card_id')) === parseInt(self.model.id);
            });
            var labels = new App.CardLabelCollection();
            labels.add(filter_labels, {
                silent: true
            });
            card.labels = labels;
            new App.CardView({
                model: card
            }).showCardModal();
        }
        trigger_dockmodal = false;
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
            card: this.model
        }));
        return this;
    },
    /**
     * deleteArchivedCard()
     * delete archived card
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    deleteArchivedCardConfirm: function(e) {
        $('.js-setting-response').html(new App.ArchivedCardDeleteConfirmView({
            model: this.model,
        }).el);
        return false;
    }
});
