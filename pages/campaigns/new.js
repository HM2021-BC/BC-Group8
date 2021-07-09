import React, { Component } from 'react';
import { Form, Button, Input, Message, Dropdown } from 'semantic-ui-react';
import Layout from '../../components/Layout';
import factory from '../../ethereum/factory';
import web3 from '../../ethereum/web3';
import { Router } from '../../routes';
const cities = require('../../cities.json');

const citiesMapped = cities.map((item, index) => { return {
  key: item.rank,
  text: item.city + " | " + item.state,
  value: item.city
}});


const getAccounts = async () => {
  var accounts = await web3.eth.getAccounts();
  console.log(accounts, 'here')
}

getAccounts()

// console.log(cities[0], citiesMapped[0]);

class CampaignNew extends Component {
  /*state = {
    name: '',
    city: '',
    product_id: '',
    errorMessage: '',
    loading: false
  };*/
  state = {
    name: '',
    location: '',
    product_id: '',
    errorMessage: '',
    loading: false
  };

  onSubmit = async event => {
    event.preventDefault();

    this.setState({ loading: true, errorMessage: '' });

    try {
      const accounts = await web3.eth.getAccounts();
      console.log('TRY ODER CREATE')
      console.log(accounts);
      /* await factory.methods
        .createCampaign(this.state.minimumContribution, "Test creating campaign")
        .send({
          from: accounts[0]
        }); */
        console.log(parseInt(new Date().valueOf() / 20),
        this.state.name,
        this.state.location)
       /* const createdOrder = await factory.methods.createOrder(
          parseInt(new Date().valueOf() / 20),
          this.state.name,
          this.state.city,
          this.state.quantity,
          this.state.receiver
        ).call({from: accounts[0]}) */
        
        /*const createdOrder = await factory.methods.createOrder(
          parseInt(new Date().valueOf() / 20),
          this.state.name,
          this.state.city,
          this.state.quantity,
          this.state.receiver
        ).send({from: accounts[0]})*/

        const createdProduct = await factory.methods.addProduct(
          parseInt(new Date().valueOf() / 20),
          this.state.name,
          this.state.location,
        ).send({from: accounts[0]})

        console.log('created product');
      Router.pushRoute('/');
    } catch (err) {
      console.log('CATH ODER CREATE')
      this.setState({ errorMessage: err.message });
    }

    console.log('ODER CREATE WORKED?')
    this.setState({ loading: false });
  };

  render() {
    return (
      <Layout>
        <h3>Create a Order</h3>

        <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
          <Form.Field>
            <label>Name</label>
            <Input
              // label="wei"
              // labelPosition="right"
              placeholder='Name'
              value={this.state.name}
              onChange={event =>
                this.setState({ name: event.target.value })}
            />
          </Form.Field>

          <Form.Field>
            <label>City</label>
            <Dropdown placeholder='City' search selection options={citiesMapped} onChange={(event, data) => {
                this.setState({ city: data.value })
                console.log(this.state, data.value)}}/>
          </Form.Field>
          <Form.Field>
            {/*<label>Quantity (integer)</label>
            <Input
              // label="wei"
              // labelPosition="right"
              value={this.state.quantity}
              placeholder='Quantity'
              onChange={event =>
                this.setState({ quantity: parseInt(event.target.value) })}
              />*/}
          </Form.Field>
          <Form.Field>
            <label>Receiver</label>
            <Input
              // label="wei"
              // labelPosition="right"
              value={this.state.receiver}
              placeholder='Receiver'
              onChange={event =>
                this.setState({ receiver: event.target.value })}
            />
          </Form.Field>
          <br/>
          <strong>Name: </strong>{ this.state.name }
          <br/>
          <strong>Location: </strong>{ this.state.location }
          <br/>
          {/*<strong>Quantity: </strong>{ this.state.quantity }
          <br/>
          <strong>Receiver: </strong>{ this.state.receiver }*/}
          <br/><br/>
          <Message error header="Oops!" content={this.state.errorMessage} />
          <Button loading={this.state.loading} primary>
            Create Order!
          </Button>
        </Form>
      </Layout>
    );
  }
}

export default CampaignNew;
