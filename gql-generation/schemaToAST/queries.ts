import { GraphQLObjectType } from "graphql";
import * as Elm from "../elmAST";

export const createModuleForQueries = (
    rootModuleName: string,
    queryObject: GraphQLObjectType<any, any>
  ): Elm.Module => {
    
    const qqlFields = queryObject.getFields()

    const queryRecordFields: {[key:string]:Elm.TypeReference} = {}

    for(const fieldName in qqlFields) {
        const field = qqlFields[fieldName]

        const inputFields: {[key:string]:Elm.TypeReference} = {}

        field.args.forEach(arg => {
            inputFields[arg.name] = Elm.typeReference(Elm.varRef(arg.type.toString()))
        })

        const inputRecord = Elm.recordType(inputFields)
        queryRecordFields[fieldName] = inputRecord
    }

    // const recordType = Elm.recordType(fields)

    // console.log({f: queryObject.getFields()})

    throw new Error("Unimpl")
}