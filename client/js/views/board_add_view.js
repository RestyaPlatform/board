/**
 * @fileOverview This file has functions related to board add view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: workflow template collection
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardAddView View
 * @class BoardAddView
 * @constructor
 * @extends Backbone.View
 */
App.BoardAddView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/board_add'],
    tagName: 'ul',
    events: {
        'click .js-change-visibility': 'showAllVisibility',
        'click .js-select': 'selectBoardVisibility',
        'submit form#BoardAddForm': 'submitBoardAdd',
    },
    className: 'list-unstyled',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            templates: this.model
        }));
        this.showTooltip();
        return this;
    },
    showAllVisibility: function(e) {
        e.preventDefault();
        $('.js-open-dropdown').addClass('open');
        $('.js-visibility-container').html('');
        var visibility = $('#inputBoardAddVisibility').val();
        $('.js-visibility-chooser').html(new App.ShowAllVisibilityView({
            model: visibility
        }).el);

        return false;
    },
    /**
     * selectBoardVisibility()
     * change the board visibility
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    selectBoardVisibility: function(e) {
        var name = $(e.currentTarget).attr('name');
        var value = 0;
        $('#js-board-add-organization').html('');
        if (name == 'org') {
            value = 1;
            this.showBoardAddeOrganizationForm(e);
        } else if (name == 'public') {
            value = 2;
        }
        var content = new App.SelectedBoardVisibilityView({
            model: name
        }).el;
        $('#inputBoardAddVisibility').val(value);
        $('.js-visibility-container').html(content);
        content = '';
        $('.js-board-add-dropdown').removeClass('open');
        return false;
    },
    submitBoardAdd: function(e) {
        e.preventDefault();
        var data = $(e.target).serializeObject();
        var board = new App.Board();
        board.url = api_url + 'boards.json';
        board.save(data, {
            success: function(model, response) {
                App.boards.add(response.simple_board);
                if (response.simple_board.lists !== null) {
                    App.boards.get(parseInt(response.simple_board.id)).lists.add(response.simple_board.lists);
                }
                app.navigate('#/board/' + response.id, {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * showChangeOrganizationForm()
     * show board organiztion change form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardAddeOrganizationForm: function(e) {
        e.preventDefault();
        organizations = auth_user_organizations;
        if (auth_user_organizations !== null && _.isUndefined(auth_user_organizations.models)) {
            organizations.add(JSON.parse(auth_user_organizations));
        }
        auth_user_organizations = organizations;
        $('#js-board-add-organization').html(new App.BoardAddOrganizationFormView({
            model: auth_user_organizations
        }).el);
    }
});
