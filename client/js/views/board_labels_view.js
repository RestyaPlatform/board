App.BoardLabelsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
            if (!_.isUndefined(authuser.user) && !_.isUndefined(this.model.board_users)) {
                var board_user_role_id = this.model.board_users.findWhere({
                    user_id: parseInt(authuser.user.id)
                });
                if (!_.isEmpty(board_user_role_id)) {
                    this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
                }
            }
        }
        this.labels = options.labels;
        this.render();
    },
    template: JST['templates/board_labels'],
    tagName: 'li',
    converter: new showdown.Converter(),
    /** 
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete-labels': 'deleteLabels',
        'click .js-show-edit-card-label-form': 'showCardLabelEditForm',
        'click .js-card-label-color-pick': 'colorPicker',
        'click .js-hide-edit-card-label-form': 'hideCardLabelEditForm',
        'click .js-show-card-label-colorpicker': 'showCardLabelColorpicker'
    },
    deleteLabels: function(e) {
        var label_id = $(e.currentTarget).data('id');
        $('.js-setting-response').html(new App.LabelDeleteConfirmView({
            model: this.model,
            label_id: label_id
        }).el);
        return false;
    },
    /**
     * showCardLabelEditForm()
     * display card label edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showCardLabelEditForm: function(e) {
        var self = this;
        $('.js-side-bar-' + this.model.id).addClass('side-bar-large');
        this.model.labels.setSortField('name', 'asc');
        this.model.labels.sort();
        var label_id = $(e.currentTarget).data('id');
        var label = this.labels.findWhere({
            'board_id': self.model.id,
            'label_id': label_id
        });
        $('.js-setting-response').html(new App.BoardLabelsEditView({
            model: this.model,
            label: label
        }).el);
        var headerH = $('header').height();
        var windowH = $(window).height();
        var footerH = $('footer').height();
        var boardH = windowH - headerH - footerH - 14;
        $('.member-modal.js-pre-scrollable').css({
            'max-height': boardH - 50,
            'overflow-y': 'auto'
        });
        return false;
    },
    /**
     * hideCardLabelEditForm()
     * hide the card label edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    hideCardLabelEditForm: function(e) {
        e.preventDefault();
        $(e.currentTarget).parents('form').addClass('hide').prev('.js-show-edit-card-label-form').removeClass('hide');
        $(e.currentTarget).closest('li').find('.js-delete-labels-icon').removeClass('hide');
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
    colorPicker: function(e) {
        var self = this;
        var color = $(e.target).closest('li').data('color');
        var label_id = $(e.target).closest('ul').data('label_id');
        var data = {
            color: color,
            id: label_id
        };
        self.model.url = api_url + 'labels/' + label_id + '.json';
        self.model.save(data, {
            patch: true,
            success: function(model, response) {
                self.model.labels.findWhere({
                    label_id: parseInt(label_id)
                }).set('color', color);
            }
        });
        return false;
    },
    /**
     * showCardLabelColorpicker()
     * show card label colorpicker form
     * @param e
     * @type Object(DOM event)
     */
    showCardLabelColorpicker: function(e) {
        e.preventDefault();
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('div.dropdown').addClass('open');
        return false;
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
            board: this.model,
            board_labels: this.labels,
            converter: this.converter
        }));
        this.showTooltip();
        return this;
    }
});
